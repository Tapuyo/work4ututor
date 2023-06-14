// ignore_for_file: unused_import, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/ui/web/tutor/subscription/subscription_type.dart';
import 'package:wokr4ututor/utils/themes.dart';

import '../../../../shared_components/responsive_builder.dart';

class ClassesMain extends HookWidget {
  const ClassesMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ResponsiveBuilder(mobileBuilder: (context, constraints) {
      return Container(
        width: size.width - 300,
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black45,
                  width: .1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        'Hello Username, welcome to Work4uTutor!',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]),
                    Row(children: [
                      Container(
                        width: 200,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kColorPrimary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 200,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kColorPrimary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 200,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: .2,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kColorLight,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.trophy,
                          color: kColorPrimary,
                          size: 35,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const SubscriptionType();
                            },
                          );
                        },
                        child: Container(
                            width: 180,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kColorYellow,
                              boxShadow: [
                                BoxShadow(
                                    color: kColorYellow.withOpacity(0.5),
                                    offset: const Offset(5, 7),
                                    blurRadius: 1.5,
                                    spreadRadius: -2)
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'PAY NOW',
                                style: TextStyle(
                                    color: kColorBlue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ]),
                    Row(children: const [
                      Text(
                        'Account not subscribe, please subscribe to complete your profile.',
                        style: TextStyle(color: kColorDarkRed, fontSize: 13),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: size.width - 310,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorPrimary,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "DASHBOARD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                   Spacer(),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 350) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF8EF291),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.bookOpen,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Enrolled Classes",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 350) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 217, 111, 1),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.graduationCap,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Active Classes",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 350) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kColorLight,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.trophy,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Completed Classes",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 350) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF8EF291),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.person,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Total Students",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 350) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 217, 111, 1),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.boxOpen,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Total Classes",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 350) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kColorLight,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.coins,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Total Earnings",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      );
    }, tabletBuilder: (context, constraints) {
      return Container(
        width: size.width,
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(children: [
            Card(
              margin: const EdgeInsets.all(4),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Colors.black45,
                  //   width: .1,
                  // ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    children: [
                      Row(children: const [
                        Text(
                          'Hello Username, welcome to Work4uTutor!',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ]),
                      Row(children: [
                        Container(
                          width: 200,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kColorPrimary,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 200,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kColorPrimary,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 200,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: .2,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kColorLight,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.trophy,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const SubscriptionType();
                              },
                            );
                          },
                          child: Container(
                              width: 180,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kColorYellow,
                                boxShadow: [
                                  BoxShadow(
                                      color: kColorYellow.withOpacity(0.5),
                                      offset: const Offset(5, 7),
                                      blurRadius: 1.5,
                                      spreadRadius: -2)
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'PAY NOW',
                                  style: TextStyle(
                                      color: kColorBlue,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ]),
                      Row(children: const [
                        Text(
                          'Account not subscribe, please subscribe to complete your profile.',
                          style: TextStyle(color: kColorDarkRed, fontSize: 13),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: size.width,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorPrimary,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "DASHBOARD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                   Spacer(),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 50) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF8EF291),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.bookOpen,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Enrolled Classes",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 50) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 217, 111, 1),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.graduationCap,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Active Classes",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 50) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kColorLight,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.trophy,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Completed Classes",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 50) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF8EF291),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.person,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Total Students",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 50) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 217, 111, 1),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.boxOpen,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Total Classes",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.center,
                  width: (size.width - 50) / 3,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black45,
                      width: .2,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kColorLight,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.coins,
                            color: kColorPrimary,
                            size: 35,
                          ),
                        ),
                        const Text(
                          "0",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary,
                          ),
                        ),
                        const Text(
                          "Total Earnings",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: kColorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      );
    }, desktopBuilder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(children: [
          Card(
            margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  children: [
                    Row(children: const [
                      Text(
                        'Hello Username, welcome to Work4uTutor!',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]),
                    Row(children: [
                      Container(
                        width: 200,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kColorPrimary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 200,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kColorPrimary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 200,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: .2,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kColorLight,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.trophy,
                          color: kColorPrimary,
                          size: 35,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const SubscriptionType();
                            },
                          );
                        },
                        child: Container(
                            width: 180,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kColorYellow,
                              boxShadow: [
                                BoxShadow(
                                    color: kColorYellow.withOpacity(0.5),
                                    offset: const Offset(5, 7),
                                    blurRadius: 1.5,
                                    spreadRadius: -2)
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'PAY NOW',
                                style: TextStyle(
                                    color: kColorBlue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                      ),
                    ]),
                    Row(children: const [
                      Text(
                        'Account not subscribe, please subscribe to complete your profile.',
                        style: TextStyle(color: kColorDarkRed, fontSize: 13),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
            elevation: 4,
            child: Container(
              height: 50,
              width: size.width - 310,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: kColorPrimary,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:const [
                  Text(
                    "DASHBOARD",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                   Spacer(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      elevation: 4,
                      child: Container(
                        alignment: Alignment.center,
                        width: (size.width - 350) / 3,
                        height: 230,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF8EF291),
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.bookOpen,
                                  color: kColorPrimary,
                                  size: 35,
                                ),
                              ),
                              const Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: kColorPrimary,
                                ),
                              ),
                              const Text(
                                "Enrolled Classes",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: kColorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Card(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      elevation: 4,
                      child: Container(
                        alignment: Alignment.center,
                        width: (size.width - 350) / 3,
                        height: 230,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 217, 111, 1),
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.graduationCap,
                                  color: kColorPrimary,
                                  size: 35,
                                ),
                              ),
                              const Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: kColorPrimary,
                                ),
                              ),
                              const Text(
                                "Active Classes",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: kColorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Card(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      elevation: 4,
                      child: Container(
                        alignment: Alignment.center,
                        width: (size.width - 350) / 3,
                        height: 230,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kColorLight,
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.trophy,
                                  color: kColorPrimary,
                                  size: 35,
                                ),
                              ),
                              const Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: kColorPrimary,
                                ),
                              ),
                              const Text(
                                "Completed Classes",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: kColorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Card(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      elevation: 4,
                      child: Container(
                        alignment: Alignment.center,
                        width: (size.width - 350) / 3,
                        height: 230,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF8EF291),
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.person,
                                  color: kColorPrimary,
                                  size: 35,
                                ),
                              ),
                              const Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: kColorPrimary,
                                ),
                              ),
                              const Text(
                                "Total Students",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: kColorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Card(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      elevation: 4,
                      child: Container(
                        alignment: Alignment.center,
                        width: (size.width - 350) / 3,
                        height: 230,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 217, 111, 1),
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.boxOpen,
                                  color: kColorPrimary,
                                  size: 35,
                                ),
                              ),
                              const Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: kColorPrimary,
                                ),
                              ),
                              const Text(
                                "Total Classes",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: kColorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Card(
                      margin: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      elevation: 4,
                      child: Container(
                        alignment: Alignment.center,
                        width: (size.width - 350) / 3,
                        height: 230,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kColorLight,
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.coins,
                                  color: kColorPrimary,
                                  size: 35,
                                ),
                              ),
                              const Text(
                                "0",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: kColorPrimary,
                                ),
                              ),
                              const Text(
                                "Total Earnings",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: kColorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      );
    });
  }
}
