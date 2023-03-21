import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/ui/web/login/login.dart';
import 'package:wokr4ututor/ui/web/signup/student_signup.dart';
import 'package:wokr4ututor/ui/web/signup/tutor_signup.dart';

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
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 200,
          ),
          SizedBox(
            height: 200,
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
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
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
                print('Pressed');
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
                primary: Colors.white,
                onSurface: Colors.white,
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
                print('Pressed');
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
                primary: Colors.white,
                onSurface: Colors.white,
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
                primary: Colors.white,
                onSurface: Colors.white,
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
                primary: Colors.white,
                onSurface: Colors.white,
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
          const SizedBox(
            width: 200,
          )
        ],
      ),
    );
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
  const DashboardMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: 250,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black45,
          width: .5,
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
            height: 45,
            width: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
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
              icon: const Icon(Icons.language_rounded),
              label: const Text('SCHEDULE'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
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
              icon: const Icon(Icons.language_rounded),
              label: const Text('MESSAGES'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
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
              icon: const Icon(Icons.language_rounded),
              label: const Text('CLASSES INQUIRY'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
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
              icon: const Icon(Icons.language_rounded),
              label: const Text('STUDENTS ENROLLED'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Color.fromRGBO(1, 118, 132, 1), // your color here
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
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
              icon: const Icon(Icons.language_rounded),
              label: const Text('PERFORMANCE'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Color.fromRGBO(1, 118, 132, 1), // your color here
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
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
              icon: const Icon(Icons.language_rounded),
              label: const Text('SETTING'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Color.fromRGBO(1, 118, 132, 1), // your color here
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
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
                print('Pressed');
              },
              icon: const Icon(Icons.language_rounded),
              label: const Text('HELP'),
            ),
          ),
          
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 45,
            width: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromRGBO(1, 118, 132, 1),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                backgroundColor: const Color.fromRGBO(103, 195, 208, 1),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Color.fromRGBO(1, 118, 132, 1), // your color here
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
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
                print('Pressed');
              },
              icon: const Icon(Icons.language_rounded),
              label: const Text('LOGOUT'),
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
