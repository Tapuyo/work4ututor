// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/ui/web/login/login.dart';
import 'package:work4ututor/ui/web/signup/student_signup.dart';
import 'package:work4ututor/ui/web/signup/tutor_signup.dart';

import '../provider/chatmessagedisplay.dart';
import '../provider/classinfo_provider.dart';
import '../provider/init_provider.dart';
import '../services/getunreadmessages.dart';
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
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(top: 0),
              width: 240,
              child: Image.asset(
                "assets/images/WORK4U_NO_BG.png",
                alignment: Alignment.topCenter,
                fit: BoxFit.cover,
              ),
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
                //  html.window.open(
                //                                                       '/#/account/student',
                //                                                       '_blank');
                GoRouter.of(context).go('/account/student');
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
                GoRouter.of(context).go('/account/tutor');
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
                GoRouter.of(context).go('/');
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
            width: 100,
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
          // Center(
          //   child: Container(
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.white,
          //     ),
          //     child: IconButton(
          //       icon: const Icon(Icons.person),
          //       iconSize: 30,
          //       color: const Color.fromARGB(255, 9, 93, 116),
          //       tooltip: 'Log Out',
          //       onPressed: () async {
          //         List<String> countryNames = getCountries();

          //         // Call the function to save the country names to Firestore
          //         saveCountryNamesToFirestore(countryNames);
          //         // const url =
          //         //     'https://www.facebook.com'; // Replace with the URL you want to navigate to
          //         // if (await canLaunchUrl(Uri.parse(url))) {
          //         //   await launchUrl(Uri.parse(url));
          //         // } else {
          //         //   throw 'Could not launch $url';
          //         // }
          //       },
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   width: 100,
          // )
        ],
      ),
    );
  }
}
class NavBarMenu extends HookWidget {
    final String uID;

 NavBarMenu(this.uID, {Key? key}) : super(key: key);
  final AuthService _auth = AuthService();
  @override
Widget build(BuildContext context) {
 
  Provider.of<MessageNotifier>(context, listen: false).getHistory(uID, 'tutor');
  final int menuIndex = context.select((InitProvider p) => p.menuIndex);
  final AuthService _auth = AuthService();
  return Column(
    children: <Widget>[
      GestureDetector(
        onTap: () {
          final provider = context.read<InitProvider>();
          provider.setMenuIndex(0);
        },
        child: Card(
          margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
          elevation: 4,
          child: Container(
            height: 50,
            width: 260,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: kSecondarycolor,
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
      ),
      const SizedBox(
        height: 10,
      ),
      Card(
        margin: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        elevation: 4,
        child: SizedBox(
          width: 260,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 220,
                  decoration: menuIndex != 0
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0)
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            colors: buttonFocuscolors,
                          ),
                          color: Colors.deepPurple.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      minimumSize:
                          MaterialStateProperty.all(const Size(220, 50)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      // elevation: MaterialStateProperty.all(3),
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      final provider = context.read<InitProvider>();
                      provider.setMenuIndex(0);
                      final provider1 =
                          context.read<ViewClassDisplayProvider>();
                      provider1.setViewClassinfo(false);
                      final provider2 = context.read<ChatDisplayProvider>();
                      provider2.setOpenMessage(false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: 30,
                            color: menuIndex == 0 ? Colors.white : kColorGrey,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: menuIndex == 0 ? Colors.white : kColorGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Container(
                width: 220,
                decoration: menuIndex != 1
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          colors: buttonFocuscolors,
                        ),
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(220, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    final provider = context.read<InitProvider>();
                    provider.setMenuIndex(1);
                    final provider1 = context.read<ViewClassDisplayProvider>();
                    provider1.setViewClassinfo(false);
                    final provider2 = context.read<ChatDisplayProvider>();
                    provider2.setOpenMessage(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 35,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 30,
                          color: menuIndex == 1 ? Colors.white : kColorGrey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Calendar',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  menuIndex == 1 ? Colors.white : kColorGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Container(
                width: 220,
                decoration: menuIndex != 4
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          colors: buttonFocuscolors,
                        ),
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(220, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    final provider = context.read<InitProvider>();
                    provider.setMenuIndex(4);
                    // final provider1 = context.read<ViewClassDisplayProvider>();
                    // provider1.setViewClassinfo(false);
                    final provider2 = context.read<ChatDisplayProvider>();
                    provider2.setOpenMessage(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 35,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.supervised_user_circle_outlined,
                          size: 30,
                          color: menuIndex == 4 ? Colors.white : kColorGrey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Students',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 4
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  menuIndex == 4 ? Colors.white : kColorGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              // Consumer<GotMessageProvider>(builder: (context, data, _) {
              //   bool status = data.gotMessage;
              //   return
              Container(
                width: 220,
                decoration: menuIndex != 2
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          colors: buttonFocuscolors,
                        ),
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(220, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    final provider = context.read<InitProvider>();
                    provider.setMenuIndex(2);
                    final provider1 = context.read<ViewClassDisplayProvider>();
                    provider1.setViewClassinfo(false);
                    // final provider2 = context.read<ChatDisplayProvider>();
                    // provider2.setOpenMessage(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 35,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 30,
                          color: menuIndex == 2 ? Colors.white : kColorGrey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Messages',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 2
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  menuIndex == 2 ? Colors.white : kColorGrey),
                        ),
                        const Spacer(),
                        Consumer<MessageNotifier>(
                            builder: (context, messagedetails, child) {
                          return _buildNotif(messagedetails.messages.length);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              // }),

              const SizedBox(
                height: 15,
              ),
              Container(
                width: 220,
                decoration: menuIndex != 5
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          colors: buttonFocuscolors,
                        ),
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(220, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    final provider = context.read<InitProvider>();
                    provider.setMenuIndex(5);
                    final provider1 = context.read<ViewClassDisplayProvider>();
                    provider1.setViewClassinfo(false);
                    final provider2 = context.read<ChatDisplayProvider>();
                    provider2.setOpenMessage(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 35,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.feedback_outlined,
                          size: 30,
                          color: menuIndex == 5 ? Colors.white : kColorGrey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Performance',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 5
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  menuIndex == 5 ? Colors.white : kColorGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Container(
                width: 220,
                decoration: menuIndex != 6
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          colors: buttonFocuscolors,
                        ),
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(220, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    final provider = context.read<InitProvider>();
                    provider.setMenuIndex(6);
                    final provider1 = context.read<ViewClassDisplayProvider>();
                    provider1.setViewClassinfo(false);
                    final provider2 = context.read<ChatDisplayProvider>();
                    provider2.setOpenMessage(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 35,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.settings,
                          size: 30,
                          color: menuIndex == 6 ? Colors.white : kColorGrey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 6
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  menuIndex == 6 ? Colors.white : kColorGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 220,
                decoration: menuIndex != 7
                    ? BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 4),
                              blurRadius: 5.0)
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          colors: buttonFocuscolors,
                        ),
                        color: Colors.deepPurple.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(220, 50)),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    // elevation: MaterialStateProperty.all(3),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    final provider = context.read<InitProvider>();
                    provider.setMenuIndex(7);
                    final provider1 = context.read<ViewClassDisplayProvider>();
                    provider1.setViewClassinfo(false);
                    final provider2 = context.read<ChatDisplayProvider>();
                    provider2.setOpenMessage(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 35,
                      top: 10,
                      bottom: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.help_outlined,
                          size: 30,
                          color: menuIndex == 7 ? Colors.white : kColorGrey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Help',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: menuIndex == 7
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  menuIndex == 7 ? Colors.white : kColorGrey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 50,
                width: 220,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(left: 50),
                    alignment: Alignment.centerLeft,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    CoolAlert.show(
                      context: context,
                      barrierDismissible: false,
                      width: 200,
                      type: CoolAlertType.confirm,
                      text: 'You want to Log Out?',
                      confirmBtnText: 'Proceed',
                      confirmBtnColor: Colors.greenAccent,
                      cancelBtnText: 'Go back',
                      showCancelBtn: true,
                      cancelBtnTextStyle: const TextStyle(color: Colors.red),
                      onCancelBtnTap: () {
                        Navigator.of(context).pop;
                      },
                      onConfirmBtnTap: () async {
                        final provider = context.read<ChatDisplayProvider>();
                        provider.setOpenMessage(false);
                        final provider1 = context.read<InitProvider>();
                        provider1.setMenuIndex(0);
                        await _auth.signOutAnon();
                        deleteAllData();
                        // ignore: use_build_context_synchronously
                        GoRouter.of(context).go('/');
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                    size: 30,
                    color: kColorPrimary,
                  ),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 15,
                      color: kColorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Container(
              //   height: 50,
              //   width: 220,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.rectangle,
              //     color: Color.fromRGBO(1, 118, 132, 1),
              //     borderRadius: BorderRadius.all(Radius.circular(25)),
              //   ),
              //   child: TextButton.icon(
              //     style: TextButton.styleFrom(
              //       padding: const EdgeInsets.only(left: 50),
              //       alignment: Alignment.centerLeft,
              //       foregroundColor: Colors.white,
              //       disabledBackgroundColor: Colors.white,
              //       backgroundColor: kColorSecondary,
              //       shape: RoundedRectangleBorder(
              //         side: const BorderSide(
              //           color:
              //               Color.fromRGBO(1, 118, 132, 1), // your color here
              //           width: 1,
              //         ),
              //         borderRadius: BorderRadius.circular(24.0),
              //       ),
              //       // ignore: prefer_const_constructors
              //       textStyle: TextStyle(
              //         color: Colors.black,
              //         fontSize: 12,
              //         fontStyle: FontStyle.normal,
              //         decoration: TextDecoration.none,
              //       ),
              //     ),
              //     onPressed: () async {
              //       CoolAlert.show(
              //         context: context,
              //         barrierDismissible: false,
              //         width: 200,
              //         type: CoolAlertType.confirm,
              //         text: 'You want to Log Out?',
              //         confirmBtnText: 'Proceed',
              //         confirmBtnColor: Colors.greenAccent,
              //         cancelBtnText: 'Go back',
              //         showCancelBtn: true,
              //         cancelBtnTextStyle: const TextStyle(color: Colors.red),
              //         onCancelBtnTap: () {
              //           Navigator.of(context).pop;
              //         },
              //         onConfirmBtnTap: () async {
              //           final provider = context.read<ChatDisplayProvider>();
              //           provider.setOpenMessage(false);
              //           await _auth.signOutAnon();
              //           deleteAllData();
              //           // ignore: use_build_context_synchronously
              //           GoRouter.of(context).go('/');
              //         },
              //       );
              //     },
              //     icon: const Icon(
              //       Icons.logout_outlined,
              //       size: 30,
              //     ),
              //     label: const Text(
              //       'LOG OUT',
              //       style: TextStyle(fontSize: 15),
              //     ),
              //   ),
              // ),

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
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => const TermPage(
                                        pdfurl: '',
                                      ));
                            }),
                      const TextSpan(text: ' / '),
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
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => const TermPage(
                                        pdfurl: '',
                                      ));
                            }),
                      const TextSpan(text: '\nCopyrights @ 2023 Work4uTutor'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
}
_buildNotif(int data) {
  return (data == null || data <= 0)
      ? Container()
      : Container(
          width: 30,
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: kSecondarybuttonblue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            (data >= 100) ? "99+" : "$data",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
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
                  MaterialPageRoute(
                      builder: (context) => const FindTutor(
                            userid: '',
                          )),
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
