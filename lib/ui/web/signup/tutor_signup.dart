// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:wokr4ututor/components/tutordialog.dart';
import 'package:wokr4ututor/components/nav_bar.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/shared_components/responsive_builder.dart';
import 'package:wokr4ututor/ui/auth/auth.dart';
import 'package:wokr4ututor/ui/web/login/login.dart';
import 'package:wokr4ututor/ui/web/signup/student_signup.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_information_signup.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../terms/termpage.dart';

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
String uType = "tutor";
//textinputs
TextEditingController tEmail = TextEditingController();
TextEditingController tPassword = TextEditingController();
TextEditingController tConPassword = TextEditingController();

String error = '';
bool obscure = true;
bool obscurecon = true;
final scafoldKey = GlobalKey<ScaffoldState>();

class _TutorSignupState extends State<TutorSignup> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ResponsiveBuilder(
            mobileBuilder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/Teacher (4).jpg"),
                  fit: BoxFit.cover,
                )),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: kSpacing / 2),
                            child: ClipRect(
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
                      SignUp(),
                      // It will cover 1/3 of free spaces
                    ],
                  ),
                ),
              );
            },
            tabletBuilder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/Teacher (4).jpg"),
                  fit: BoxFit.cover,
                )),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: kSpacing / 2),
                            child: ClipRect(
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
                      SignUp(),
                      // It will cover 1/3 of free spaces
                    ],
                  ),
                ),
              );
            },
            desktopBuilder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/Teacher (4).jpg"),
                  fit: BoxFit.cover,
                )),
                child: SingleChildScrollView(
                  controller: ScrollController(),
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
            },
          ),
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
  late String password;
  double strength = 0;

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

  String displayText = 'Please enter a password';

  void checkPassword(String value) {
    password = value.trim();

    if (password.isEmpty) {
      setState(() {
        strength = 0;
        displayText = 'Please enter you password';
      });
    } else if (password.length < 6) {
      setState(() {
        strength = 1 / 4;
        displayText = 'Your password is too short';
      });
    } else if (password.length < 8) {
      setState(() {
        strength = 2 / 4;
        displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(password) || !numReg.hasMatch(password)) {
        setState(() {
          // Password length >= 8
          // But doesn't contain both letter and digit characters
          strength = 3 / 4;
          displayText = 'Your password is strong';
        });
      } else {
        // Password length >= 8
        // Password contains both letter and digit characters
        setState(() {
          strength = 1;
          displayText = 'Your password is great';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobileBuilder: (BuildContext context, BoxConstraints constraints) {
        return ClipRect(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 420,
              alignment: Alignment.centerRight,
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
                        style: TextStyle(
                          // textStyle: Theme.of(context).textTheme.headlineMedium,
                          color: Color.fromRGBO(1, 118, 132, 1),
                          fontSize: 18,
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
                              controller: tEmail,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 12),
                                hintText: 'Email',
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter an email' : null,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 380,
                            height: 60,
                            child: TextFormField(
                              controller: tPassword,
                              obscureText: obscure,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 12),
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
                              validator: (val) => val!.length < 6
                                  ? 'Enter a 6+ valid password'
                                  : null,
                              onChanged: (val) {
                                checkPassword(val);
                              },
                            ),
                          ),
                          Visibility(
                            visible: tPassword.text.isNotEmpty,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 380,
                                    height: 5,
                                    child: LinearProgressIndicator(
                                      value: strength,
                                      backgroundColor: Colors.grey[300],
                                      color: strength <= 1 / 4
                                          ? Colors.red
                                          : strength == 2 / 4
                                              ? Colors.yellow
                                              : strength == 3 / 4
                                                  ? Colors.blue
                                                  : Colors.green,
                                      minHeight: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),

                                  // The message about the strength of the entered password
                                  Text(
                                    displayText,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 380,
                            height: 60,
                            child: TextFormField(
                              controller: tConPassword,
                              obscureText: obscurecon,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 12),
                                hintText: 'Confirm Password',
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    onPressed: () {
                                      setState(() {
                                        obscurecon = !obscurecon;
                                      });
                                    },
                                    icon: Icon(Icons.remove_red_eye_rounded),
                                    iconSize: 20,
                                  ),
                                ),
                                suffixIconColor: Colors.black,
                              ),
                              validator: (val) => val != tPassword.text
                                  ? 'Password not Match'
                                  : null,
                              // onChanged: (val) {
                              //   tConPassword = val;
                              // },
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
                              color: Color.fromRGBO(
                                  1, 118, 132, 1), // your color here
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                        onPressed: strength < 1 / 2
                            ? null
                            : () async {
                                // addUser(tEmail, tPassword, uType);
                                if (formKey.currentState!.validate()) {
                                  dynamic result =
                                      await _auth.registerwEmailandPassword(
                                          tEmail.text, tPassword.text, uType);
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

                                        QuickAlert.show(
                                          context: context,
                                          headerBackgroundColor: Colors.red,
                                          type: QuickAlertType.error,
                                          title: 'Oops...',
                                          text: result,
                                          backgroundColor: Colors.black,
                                          titleColor: Colors.white,
                                          textColor: Colors.white,
                                        );
                                      } else {
                                        result =
                                            "Account succesfully registered! Click okay to continue.";
                                        print(result.uid);
                                        QuickAlert.show(
                                          context: context,
                                          headerBackgroundColor: Colors.green,
                                          type: QuickAlertType.success,
                                          text: result,
                                          confirmBtnText: 'Okay',
                                          onConfirmBtnTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TutorInfo(
                                                        uid: result.uid,
                                                        email: result.email,
                                                      )),
                                            );
                                          },
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
        return ClipRect(
          child: Container(
            width: 420,
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                            controller: tEmail,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 12),
                              hintText: 'Email',
                            ),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an email' : null,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 380,
                          height: 60,
                          child: TextFormField(
                            controller: tPassword,
                            obscureText: obscure,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 12),
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
                            validator: (val) => val!.length < 6
                                ? 'Enter a 6+ valid password'
                                : null,
                            onChanged: (val) {
                              checkPassword(val);
                            },
                          ),
                        ),
                        Visibility(
                          visible: tPassword.text.isNotEmpty,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 380,
                                  height: 5,
                                  child: LinearProgressIndicator(
                                    value: strength,
                                    backgroundColor: Colors.grey[300],
                                    color: strength <= 1 / 4
                                        ? Colors.red
                                        : strength == 2 / 4
                                            ? Colors.yellow
                                            : strength == 3 / 4
                                                ? Colors.blue
                                                : Colors.green,
                                    minHeight: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                                // The message about the strength of the entered password
                                Text(
                                  displayText,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 380,
                          height: 60,
                          child: TextFormField(
                            controller: tConPassword,
                            obscureText: obscurecon,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 12),
                              hintText: 'Confirm Password',
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(0),
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onPressed: () {
                                    setState(() {
                                      obscurecon = !obscurecon;
                                    });
                                  },
                                  icon: Icon(Icons.remove_red_eye_rounded),
                                  iconSize: 20,
                                ),
                              ),
                              suffixIconColor: Colors.black,
                            ),
                            validator: (val) => val != tPassword.text
                                ? 'Password not Match'
                                : null,
                            // onChanged: (val) {
                            //   tConPassword = val;
                            // },
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
                            color: Color.fromRGBO(
                                1, 118, 132, 1), // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: strength < 1 / 2
                          ? null
                          : () async {
                              // addUser(tEmail, tPassword, uType);
                              if (formKey.currentState!.validate()) {
                                dynamic result =
                                    await _auth.registerwEmailandPassword(
                                        tEmail.text, tPassword.text, uType);
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

                                      QuickAlert.show(
                                        context: context,
                                        headerBackgroundColor: Colors.red,
                                        type: QuickAlertType.error,
                                        title: 'Oops...',
                                        text: result,
                                        backgroundColor: Colors.black,
                                        titleColor: Colors.white,
                                        textColor: Colors.white,
                                      );
                                    } else {
                                      result =
                                          "Account succesfully registered! Click okay to continue.";
                                      print(result.uid);
                                      QuickAlert.show(
                                        context: context,
                                        headerBackgroundColor: Colors.green,
                                        type: QuickAlertType.success,
                                        text: result,
                                        confirmBtnText: 'Okay',
                                        onConfirmBtnTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TutorInfo(
                                                      uid: result.uid,
                                                      email: result.email,
                                                    )),
                                          );
                                        },
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
          ),
        );
      },
      desktopBuilder: (BuildContext context, BoxConstraints constraints) {
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
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    " Make yourself\navailable to students\nall over the world",
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
                          controller: tEmail,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 12),
                            hintText: 'Email',
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 380,
                        height: 60,
                        child: TextFormField(
                          controller: tPassword,
                          obscureText: obscure,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 12),
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
                          validator: (val) => val!.length < 6
                              ? 'Enter a 6+ valid password'
                              : null,
                          onChanged: (val) {
                            checkPassword(val);
                          },
                        ),
                      ),
                      Visibility(
                        visible: tPassword.text.isNotEmpty,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 380,
                                height: 5,
                                child: LinearProgressIndicator(
                                  value: strength,
                                  backgroundColor: Colors.grey[300],
                                  color: strength <= 1 / 4
                                      ? Colors.red
                                      : strength == 2 / 4
                                          ? Colors.yellow
                                          : strength == 3 / 4
                                              ? Colors.blue
                                              : Colors.green,
                                  minHeight: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                              // The message about the strength of the entered password
                              Text(
                                displayText,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 380,
                        height: 60,
                        child: TextFormField(
                          controller: tConPassword,
                          obscureText: obscurecon,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 12),
                            hintText: 'Confirm Password',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(0),
                              child: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    obscurecon = !obscurecon;
                                  });
                                },
                                icon: Icon(Icons.remove_red_eye_rounded),
                                iconSize: 20,
                              ),
                            ),
                            suffixIconColor: Colors.black,
                          ),
                          validator: (val) => val != tPassword.text
                              ? 'Password not Match'
                              : null,
                          // onChanged: (val) {
                          //   tConPassword = val;
                          // },
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
                          color:
                              Color.fromRGBO(1, 118, 132, 1), // your color here
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    onPressed: strength < 1 / 2
                        ? null
                        : () async {
                            // addUser(tEmail, tPassword, uType);
                            if (formKey.currentState!.validate()) {
                              dynamic result =
                                  await _auth.registerwEmailandPassword(
                                      tEmail.text, tPassword.text, uType);
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

                                    QuickAlert.show(
                                      context: context,
                                      headerBackgroundColor: Colors.red,
                                      type: QuickAlertType.error,
                                      title: 'Oops...',
                                      text: result,
                                      backgroundColor: Colors.black,
                                      titleColor: Colors.white,
                                      textColor: Colors.white,
                                    );
                                  } else {
                                    result =
                                        "Account succesfully registered! Click okay to continue.";
                                    print(result.uid);
                                    QuickAlert.show(
                                      context: context,
                                      headerBackgroundColor: Colors.green,
                                      type: QuickAlertType.success,
                                      text: result,
                                      confirmBtnText: 'Okay',
                                      onConfirmBtnTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => TutorInfo(
                                                    uid: result.uid,
                                                    email: result.email,
                                                  )),
                                        );
                                      },
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
    );
  }
}
