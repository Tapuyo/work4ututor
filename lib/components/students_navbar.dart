// ignore_for_file: avoid_print

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../provider/chatmessagedisplay.dart';
import '../provider/classinfo_provider.dart';
import '../provider/init_provider.dart';
import '../ui/auth/auth.dart';
import '../ui/web/login/login.dart';
import '../ui/web/terms/termpage.dart';
import '../utils/themes.dart';

class StudentsMenu extends HookWidget {
  StudentsMenu({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final int menuIndex = context.select((InitProvider p) => p.menuIndex);
    return SingleChildScrollView(
      controller: ScrollController(),
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
                backgroundColor:
                    menuIndex != 0 ? kColorSecondary : kColorPrimary,
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
                final provider1 = context.read<ViewClassDisplayProvider>();
                provider1.setViewClassinfo(false);
                final provider2 = context.read<ChatDisplayProvider>();
                provider2.setOpenMessage(false);
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
                backgroundColor:
                    menuIndex != 1 ? kColorSecondary : kColorPrimary,
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
                final provider1 = context.read<ViewClassDisplayProvider>();
                provider1.setViewClassinfo(false);
                final provider2 = context.read<ChatDisplayProvider>();
                provider2.setOpenMessage(false);
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
                backgroundColor:
                    menuIndex != 3 ? kColorSecondary : kColorPrimary,
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
                final provider2 = context.read<ChatDisplayProvider>();
                provider2.setOpenMessage(false);
              },
              icon: const Icon(
                Icons.person_add,
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
                backgroundColor:
                    menuIndex != 4 ? kColorSecondary : kColorPrimary,
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
                final provider1 = context.read<ViewClassDisplayProvider>();
                provider1.setViewClassinfo(false);
              },
              icon: const Icon(
                EvaIcons.email,
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
                backgroundColor:
                    menuIndex != 9 ? kColorSecondary : kColorPrimary,
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
                provider.setMenuIndex(9);
                final provider1 = context.read<ViewClassDisplayProvider>();
                provider1.setViewClassinfo(false);
                final provider2 = context.read<ChatDisplayProvider>();
                provider2.setOpenMessage(false);
              },
              icon: const Icon(
                EvaIcons.shoppingCart,
                size: 30,
              ),
              label: const Text(
                'MY CART',
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
                backgroundColor:
                    menuIndex != 6 ? kColorSecondary : kColorPrimary,
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
                final provider1 = context.read<ViewClassDisplayProvider>();
                provider1.setViewClassinfo(false);
                final provider2 = context.read<ChatDisplayProvider>();
                provider2.setOpenMessage(false);
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
                backgroundColor:
                    menuIndex != 7 ? kColorSecondary : kColorPrimary,
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
                final provider1 = context.read<ViewClassDisplayProvider>();
                provider1.setViewClassinfo(false);
                final provider2 = context.read<ChatDisplayProvider>();
                provider2.setOpenMessage(false);
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
                await _auth.signOutAnon();
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
            height: 80,
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
                              builder: (_) => const TermPage(pdfurl: '',));
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
                              builder: (_) => const TermPage(pdfurl: '',));
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

  void deleteAllData() async {
    final box = await Hive.openBox('userID');
    await box.clear();
  }
}
