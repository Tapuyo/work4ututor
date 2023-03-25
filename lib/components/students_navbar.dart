import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../ui/auth/auth.dart';
import '../ui/web/terms/termpage.dart';

class StudentsMenu extends HookWidget {
  StudentsMenu({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height - 75,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black87,
          width: .1,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              final provider = context.read<InitProvider>();
              provider.setMenuIndex(0);
            },
            child: Container(
              height: 50,
              width: 300,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    bottomLeft: Radius.circular(0),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
              ),
              child: SizedBox(
                height: 170,
                width: 200,
                child: Image.asset(
                  "assets/images/STUDENT_DIARY_NO_BG.png",
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
              onPressed: () {
                final provider = context.read<InitProvider>();
                provider.setMenuIndex(1);
              },
              icon: const Icon(
                Icons.calendar_month,
                size: 30,
              ),
              label: const Text(
                'CLASSES',
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
              onPressed: () {
                final provider = context.read<InitProvider>();
                provider.setMenuIndex(2);
              },
              icon: const Icon(
                Icons.wechat,
                size: 30,
              ),
              label: const Text(
                'MESSAGES',
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
              onPressed: () {
                final provider = context.read<InitProvider>();
                provider.setMenuIndex(3);
              },
              icon: const Icon(
                Icons.person_add,
                size: 30,
              ),
              label: const Text(
                'BOOK CLASS',
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
              onPressed: () {
                final provider = context.read<InitProvider>();
                provider.setMenuIndex(4);
              },
              icon: const Icon(
                Icons.supervised_user_circle,
                size: 30,
              ),
              label: const Text(
                'MY INQUIRIES',
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
                print(result.toString());
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
            height: 15,
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
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => TermPage());
                        }),
                  const TextSpan(text: ' / '),
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
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => TermPage());
                        }),
                  const TextSpan(text: '\nCopyrights @ 2023 Work4uTutor'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
