import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wokr4ututor/provider/init_provider.dart';
import 'package:wokr4ututor/utils/themes.dart';

class ClassesMain extends HookWidget {
  const ClassesMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width - 250,
      child: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Column(
                    children: [
                      Row(children: [
                        const Text('Hello Marian, welcome to Work4uTutor!'),
                      ]),
                      Row(children: [
                        Container(
                          width: 200,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kColorBlue,
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
                            color: kColorBlue,
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
                            color: kColorBlue,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: kColorLight,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.trophy,
                            color: kColorBlue,
                            size: 50,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: (){
                            //TODO
                          },
                          child: Container(
                              width: 200,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
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
                      Row(children: [
                        const Text('Account not subscribe, please subscribe to complete your profile.',style: TextStyle(color: kColorDarkRed, fontSize: 12),),
                      ]),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
