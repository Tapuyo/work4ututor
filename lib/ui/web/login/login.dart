// ignore_for_file: prefer_const_constructors, avoid_print, unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:work4ututor/ui/web/login/resetpassword.dart';

import '../../../components/nav_bar.dart';
import '../../../constant/constant.dart';
import '../../../data_class/user_class.dart';
import '../../../shared_components/alphacode3.dart';
import '../../../shared_components/responsive_builder.dart';
import '../../../utils/themes.dart';
import '../../auth/auth.dart';
import '../signup/student_information_signup.dart';
import '../signup/student_signup.dart';
import '../signup/tutor_information_signup.dart';
import '../signup/tutor_signup.dart';
import '../student/main_dashboard/student_dashboard.dart';
import '../terms/termpage.dart';
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
final scafoldKey = GlobalKey<ScaffoldState>();

class _LoginPageState extends State<LoginPage> {
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
                LogScreen(),
                // It will cover 1/3 of free spaces
              ],
            ),
          ),
        ));
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
        image: AssetImage("assets/images/Student (12).jpg"),
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
                SigniN(),
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
                SigniN(),
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
                SigniN(),
                // It will cover 1/3 of free spaces
              ],
            ),
          );
        },
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
                              " Welcome Back!",
                              style: TextStyle(
                                // textStyle: Theme.of(context).textTheme.headlineMedium,
                                color: Color.fromRGBO(1, 118, 132, 1),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              " Have a great day ahead.",
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
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
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
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 16),
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
                                validator: (val) => val!.length < 6
                                    ? 'Enter a 6+ valid password'
                                    : null,
                                onChanged: (val) {
                                  userPassword = val;
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ResetPage()),
                                  );
                                },
                                child: Text(
                                  style: TextStyle(
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
                            isLoading ? null : _handleButtonPress;
                            UserData? result =
                                await _auth.signinwEmailandPassword(
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
                              if (result.role == 'tutor' &&
                                  result.status == 'unfinished') {
                                setState(() {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TutorInfo(
                                              uid: result.uid.toString(),
                                              email: result.email.toString(),
                                            )),
                                  );
                                });

                                StudentDashboardPage(
                                    uID: result.uid.toString());
                              } else if (result.role == 'tutor' &&
                                  result.status == 'completed') {
                                setState(() {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardPage(
                                            uID: result.uid.toString())),
                                  );
                                });

                                StudentDashboardPage(
                                    uID: result.uid.toString());
                              } else if (result.role == 'student' &&
                                  result.status == 'completed') {
                                setState(() {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudentDashboardPage(
                                                uID: result.uid.toString())),
                                  );
                                });
                              } else if (result.role == 'student' &&
                                  result.status == 'unfinished') {
                                setState(() {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentInfo(
                                              uid: result.uid.toString(),
                                              email: result.email,
                                            )),
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
                          " Welcome Back!",
                          style: TextStyle(
                            // textStyle: Theme.of(context).textTheme.headlineMedium,
                            color: Color.fromRGBO(1, 118, 132, 1),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          " Have a great day ahead.",
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                            validator: (val) => val!.length < 6
                                ? 'Enter a 6+ valid password'
                                : null,
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ResetPage()),
                              );
                            },
                            child: Text(
                              style: TextStyle(
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
                            color: Color.fromRGBO(
                                1, 118, 132, 1), // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        isLoading ? null : _handleButtonPress;
                        UserData? result = await _auth.signinwEmailandPassword(
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
                          if (result.role == 'tutor' &&
                              result.status == 'unfinished') {
                            setState(() {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TutorInfo(
                                          uid: result.uid.toString(),
                                          email: result.email.toString(),
                                        )),
                              );
                            });

                            StudentDashboardPage(uID: result.uid.toString());
                          } else if (result.role == 'tutor' &&
                              result.status == 'completed') {
                            setState(() {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardPage(
                                        uID: result.uid.toString())),
                              );
                            });

                            StudentDashboardPage(uID: result.uid.toString());
                          } else if (result.role == 'student' &&
                              result.status == 'completed') {
                            setState(() {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentDashboardPage(
                                        uID: result.uid.toString())),
                              );
                            });
                          } else if (result.role == 'student' &&
                              result.status == 'unfinished') {
                            setState(() {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentInfo(
                                          uid: result.uid.toString(),
                                          email: result.email,
                                        )),
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
                          " Welcome Back!",
                          style: TextStyle(
                            // textStyle: Theme.of(context).textTheme.headlineMedium,
                            color: Color.fromRGBO(1, 118, 132, 1),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          " Have a great day ahead.",
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 16),
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
                            validator: (val) => val!.length < 6
                                ? 'Enter a 6+ valid password'
                                : null,
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
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ResetPage()),
                              );
                            },
                            child: Text(
                              style: TextStyle(
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
                            color: Color.fromRGBO(
                                1, 118, 132, 1), // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        isLoading ? null : _handleButtonPress;
                        dynamic result = await _auth.signinwEmailandPassword(
                            userEmail, userPassword);
                        // 'mjselma@gmail.com',
                        // '123456');
                        if (result == null) {
                          setState(() {
                            error = 'Could not sign in w/ those credential';
                            print(error);
                             QuickAlert.show(
                              context: context,
                              headerBackgroundColor: Colors.redAccent,
                              type: QuickAlertType.error,
                              title: 'Oops...',
                              text: error,
                              backgroundColor: Colors.black,
                              titleColor: Colors.white,
                              textColor: Colors.white,
                            );
                          });
                        } else {
                          setState(() {
                            print(result.uid);
                            print(result.role);
                            _auth.adduserInfo({
                              "userID": result.uid,
                              "role": result.role,
                              "userStatus": result.status
                            });
                          });
                          if (result.role == 'tutor' &&
                              result.status == 'unfinished') {
                            setState(() {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'You will redirected to sign up!',
                                autoCloseDuration: const Duration(seconds: 1),
                                showConfirmBtn: false,
                              ).then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TutorInfo(
                                              uid: result.uid.toString(),
                                              email: result.email.toString(),
                                            )),
                                  ));
                            });

                            StudentDashboardPage(uID: result.uid.toString());
                          } else if (result.role == 'tutor' &&
                              result.status == 'completed') {
                            setState(() {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Log in Succesfully!',
                                autoCloseDuration: const Duration(seconds: 1),
                                showConfirmBtn: false,
                              ).then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardPage(
                                            uID: result.uid.toString())),
                                  ));
                            });
                          } else if (result.role == 'student' &&
                              result.status == 'completed') {
                            setState(() {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'Log in Succesfully!',
                                autoCloseDuration: const Duration(seconds: 1),
                                showConfirmBtn: false,
                              ).then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudentDashboardPage(
                                                uID: result.uid.toString())),
                                  ));
                            });
                          } else if (result.role == 'student' &&
                              result.status == 'unfinished') {
                            setState(() {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.success,
                                text: 'You will redirected to sign up!',
                                autoCloseDuration: const Duration(seconds: 1),
                                showConfirmBtn: false,
                              ).then((value) => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentInfo(
                                              uid: result.uid.toString(),
                                              email: result.email,
                                            )),
                                  ));
                            });
                          } else {
                            QuickAlert.show(
                              context: context,
                              headerBackgroundColor: Colors.redAccent,
                              type: QuickAlertType.error,
                              title: 'Oops...',
                              text: result.toString(),
                              backgroundColor: Colors.black,
                              titleColor: Colors.white,
                              textColor: Colors.white,
                            );
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
}
