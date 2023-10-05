// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/shared_components/alphacode3.dart';
import 'package:work4ututor/ui/web/login/login.dart';
import 'package:work4ututor/ui/web/signup/student_signup.dart';
import 'package:work4ututor/ui/web/signup/tutor_signup.dart';

import '../provider/init_provider.dart';
import '../ui/auth/auth.dart';
import '../ui/web/search_tutor/find_tutors.dart';
import '../ui/web/terms/termpage.dart';
import '../utils/themes.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(top: 0),
            width: 240,
            child: Image.asset(
              "assets/images/WORK4U_NO_BG.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          ),
          const Spacer(),
          Container(
            height: 38,
            width: 140,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
            width: 20,
          ),
          Container(
            height: 38,
            width: 135,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                  MaterialPageRoute(builder: (context) => const TutorSignup()),
                );
              },
              child: const Text('BECOME A TUTOR'),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            height: 38,
            width: 110,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(103, 195, 208, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('LOG IN'),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

Future<void> saveCountryNamesToFirestore(List<String> countryNames) async {
  try {
    // Get a reference to the Firestore collection
    CollectionReference countriesCollection =
        FirebaseFirestore.instance.collection('countries');

    // Clear existing data in the collection (optional)
    await countriesCollection.doc('country_names').delete();

    // Save the list of country names to Firestore
    await countriesCollection.doc('country_names').set({
      'names': countryNames,
    });

    print('Country names saved to Firestore successfully!');
  } catch (e) {
    print('Error saving country names to Firestore: $e');
  }
}

class CustomAppBarLog extends StatelessWidget {
  const CustomAppBarLog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(55, 116, 135, 1),
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 200,
          ),
          InkWell(
            child: SizedBox(
              height: 180,
              width: 250,
              child: Image.asset(
                "assets/images/worklogo.png",
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: const Icon(Icons.person),
                iconSize: 30,
                color: const Color.fromARGB(255, 9, 93, 116),
                tooltip: 'Log Out',
                onPressed: () async {
                  List<String> countryNames = getCountries();

                  // Call the function to save the country names to Firestore
                  saveCountryNamesToFirestore(countryNames);
                  // const url =
                  //     'https://www.facebook.com'; // Replace with the URL you want to navigate to
                  // if (await canLaunchUrl(Uri.parse(url))) {
                  //   await launchUrl(Uri.parse(url));
                  // } else {
                  //   throw 'Could not launch $url';
                  // }
                },
              ),
            ),
          ),
          const SizedBox(
            width: 200,
          )
        ],
      ),
    );
  }
}

Widget navbarmenu(BuildContext context) {
  // ignore: no_leading_underscores_for_local_identifiers
  final int menuIndex = context.select((InitProvider p) => p.menuIndex);
  final AuthService _auth = AuthService();
  return Column(
    children: <Widget>[
      GestureDetector(
        onTap: () {
          final provider = context.read<InitProvider>();
          provider.setMenuIndex(0);
        },
        child: Container(
          height: 50,
          width: 240,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: kColorPrimary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5)),
          ),
          child: SizedBox(
            height: 170,
            width: 200,
            child: Image.asset(
              "assets/images/TUTOR_S_DESK_NO BG.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        height: 50,
        width: 240,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: kColorSecondary,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 50),
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white,
            backgroundColor: menuIndex != 0 ? kColorSecondary : kColorPrimary,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(1, 118, 132, 1), // your color here
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            // ignore: prefer_const_constructors
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
          ),
          onPressed: () {
            final provider = context.read<InitProvider>();
            provider.setMenuIndex(0);
          },
          icon: const Icon(
            Icons.home_outlined,
            size: 30,
          ),
          label: const Text(
            'DASHBOARD',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        height: 50,
        width: 240,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: kColorSecondary,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 50),
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white,
            backgroundColor: menuIndex != 1 ? kColorSecondary : kColorPrimary,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(1, 118, 132, 1), // your color here
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            // ignore: prefer_const_constructors
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
          ),
          onPressed: () {
            final provider = context.read<InitProvider>();
            provider.setMenuIndex(1);
          },
          icon: const Icon(
            Icons.calendar_month,
            size: 30,
          ),
          label: const Text(
            'CALENDAR',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        height: 50,
        width: 240,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(1, 118, 132, 1),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 50),
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white,
            backgroundColor: menuIndex != 3 ? kColorSecondary : kColorPrimary,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(1, 118, 132, 1), // your color here
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            // ignore: prefer_const_constructors
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
          ),
          onPressed: () {
            final provider = context.read<InitProvider>();
            provider.setMenuIndex(3);
          },
          icon: const Icon(
            Icons.question_answer,
            size: 30,
          ),
          label: const Text(
            'INQUIRIES',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        height: 50,
        width: 240,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(1, 118, 132, 1),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 50),
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white,
            backgroundColor: menuIndex != 4 ? kColorSecondary : kColorPrimary,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(1, 118, 132, 1), // your color here
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            // ignore: prefer_const_constructors
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
          ),
          onPressed: () {
            final provider = context.read<InitProvider>();
            provider.setMenuIndex(4);
          },
          icon: const Icon(
            Icons.supervised_user_circle,
            size: 30,
          ),
          label: const Text(
            'STUDENTS',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        height: 50,
        width: 240,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(1, 118, 132, 1),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 50),
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white,
            backgroundColor: menuIndex != 5 ? kColorSecondary : kColorPrimary,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(1, 118, 132, 1), // your color here
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            // ignore: prefer_const_constructors
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
          ),
          onPressed: () {
            final provider = context.read<InitProvider>();
            provider.setMenuIndex(5);
          },
          icon: const Icon(
            Icons.feedback,
            size: 30,
          ),
          label: const Text(
            'PERFORMANCE',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        height: 50,
        width: 240,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(1, 118, 132, 1),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 50),
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white,
            backgroundColor: menuIndex != 6 ? kColorSecondary : kColorPrimary,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(1, 118, 132, 1), // your color here
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            // ignore: prefer_const_constructors
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
          ),
          onPressed: () {
            final provider = context.read<InitProvider>();
            provider.setMenuIndex(6);
          },
          icon: const Icon(
            Icons.settings,
            size: 30,
          ),
          label: const Text(
            'SETTINGS',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        height: 50,
        width: 240,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(1, 118, 132, 1),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 50),
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white,
            backgroundColor: menuIndex != 7 ? kColorSecondary : kColorPrimary,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(1, 118, 132, 1), // your color here
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            // ignore: prefer_const_constructors
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
          ),
          onPressed: () {
            final provider = context.read<InitProvider>();
            provider.setMenuIndex(7);
          },
          icon: const Icon(
            Icons.help_outline_rounded,
            size: 30,
          ),
          label: const Text(
            'HELP',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Container(
        height: 50,
        width: 240,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color.fromRGBO(1, 118, 132, 1),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 50),
            alignment: Alignment.centerLeft,
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white,
            backgroundColor: kColorSecondary,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Color.fromRGBO(1, 118, 132, 1), // your color here
                width: 1,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ),
            // ignore: prefer_const_constructors
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
          ),
          onPressed: () async {
            dynamic result = await _auth.signOutAnon();
            deleteAllData();
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          icon: const Icon(
            Icons.logout_outlined,
            size: 30,
          ),
          label: const Text(
            'LOG OUT',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color.fromARGB(255, 59, 59, 59),
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
            children: <TextSpan>[
              TextSpan(
                  text: 'Terms of Service',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: kColorSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => const TermPage());
                    }),
              const TextSpan(text: ' / '),
              TextSpan(
                  text: 'Privacy Policy',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: kColorSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => const TermPage());
                    }),
              const TextSpan(text: '\nCopyrights @ 2023 Work4uTutor'),
            ],
          ),
        ),
      ),
    ],
  );
}

void deleteAllData() async {
  final box = await Hive.openBox('userID');
  await box.clear();
}

class FindTutorNavbar extends StatelessWidget {
  const FindTutorNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 240,
            child: Image.asset(
              "assets/images/worklogo.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 38,
            width: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(19, 132, 150, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                // ignore: prefer_const_constructors
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                  decoration: TextDecoration.none,
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.language_rounded),
              label: const Text('LANGUAGE'),
            ),
          ),
          const Spacer(),
          Container(
            height: 38,
            width: 110,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(19, 132, 150, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                  MaterialPageRoute(builder: (context) => const FindTutor()),
                );
              },
              child: const Text('FIND TUTOR'),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            height: 38,
            width: 140,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(19, 132, 150, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
            width: 20,
          ),
          Container(
            height: 38,
            width: 135,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(19, 132, 150, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                  MaterialPageRoute(builder: (context) => const TutorSignup()),
                );
              },
              child: const Text('BECOME A TUTOR'),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            height: 38,
            width: 110,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(103, 195, 208, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: const BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
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
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('LOG IN'),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
