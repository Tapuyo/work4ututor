import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/utils/themes.dart';

class StudentsMainDashboard extends HookWidget {
  const StudentsMainDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                    GestureDetector(
                      onTap: () {
                        //TODO
                      },
                      child: Container(
                          width: 180,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kColorYellow,
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
              children: [
                Text(
                  "DASHBOARD",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Spacer(),
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
                        "Subscription Validity",
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
  }
}
