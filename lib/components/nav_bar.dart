import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/ui/web/login/login.dart';
import 'package:wokr4ututor/ui/web/signup/student_signup.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_signup.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../ui/auth/auth.dart';

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
          Container(
            height: 38,
            width: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
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
              onPressed: () {
              },
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

class CustomAppBarLog extends StatelessWidget {
   CustomAppBarLog({Key? key}) : super(key: key);
 final AuthService _auth = AuthService();
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
          SizedBox(
            height: 180,
            width: 250,
            child: Image.asset(
              "assets/images/worklogo.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
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
                onPressed: () {},
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

class DashboardMenu extends HookWidget{
   DashboardMenu({Key? key}) : super(key: key);
 final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height - 75,
      width: 300,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black45,
          width: .1,
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(5.0),
          topLeft: Radius.circular(5.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: (){
               final provider = context.read<InitProvider>();
              provider.setMenuIndex(0);
            },
            child: const SizedBox(
               height: 66,
               width: 250,
              child:  ColoredBox(
                color:  Color.fromRGBO(1, 118, 132, 1),
                
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            height: 50,
            width: 300,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: kColorPrimary,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomLeft: Radius.circular(0),topRight: Radius.circular(5),bottomRight: Radius.circular(5)),
            ),
            child: SizedBox(
            height: 150,
            width: 170,
            child: Image.asset(
              "assets/images/TUTOR_S_DESK_NO BG.png",
              alignment: Alignment.topCenter,
              fit: BoxFit.contain,
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
              color:kColorSecondary,
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
                'SCHEDULE',
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
                Icons.question_answer,
                size: 30,
              ),
              label: const Text(
                'CLASSES\nINQUIRY',
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
                'STUDENTS\nENROLLED',
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
            width: 200,
          )
        ],
      ),
    );
  }
}
