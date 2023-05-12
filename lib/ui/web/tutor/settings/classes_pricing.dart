import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../../utils/themes.dart';

class ClassesPricing extends StatefulWidget {
  const ClassesPricing({super.key});

  @override
  State<ClassesPricing> createState() => _ClassesPricingState();
}

TextEditingController _subjectsController = TextEditingController();
TextEditingController _subjectsController1 = TextEditingController();
TextEditingController _subjectsController2 = TextEditingController();
TextEditingController _subjectsController3 = TextEditingController();
TextEditingController _subjectsController4 = TextEditingController();

class _ClassesPricingState extends State<ClassesPricing> {
  @override
  Widget build(BuildContext context) {
    _subjectsController.text = 'Math, English, Chemistry';
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      width: size.width - 320,
      height: size.height - 75,
      padding: const EdgeInsets.only(left: 200, right: 200),
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 600,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: const BoxDecoration(color: kColorPrimary),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Subjects',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 600,
                    height: 60,
                    child: TextField(
                      controller: _subjectsController,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Language',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 600,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Add more subjects',
                          style: TextStyle(color: kColorPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 40,
                  width: 600,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: const BoxDecoration(color: kColorPrimary),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Math',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 350,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Price for 2 classes")),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Input price' : null,
                              onChanged: (val) {
                                // tTimezone = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Price for 3 classes")),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Input price' : null,
                              onChanged: (val) {
                                // tTimezone = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Price for 5 classes")),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Input price' : null,
                              onChanged: (val) {
                                // tTimezone = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 600,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: const BoxDecoration(color: kColorPrimary),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'English',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 350,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Price for 2 classes")),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Input price' : null,
                              onChanged: (val) {
                                // tTimezone = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Price for 3 classes")),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Input price' : null,
                              onChanged: (val) {
                                // tTimezone = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Price for 5 classes")),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Input price' : null,
                              onChanged: (val) {
                                // tTimezone = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: 600,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: const BoxDecoration(color: kColorPrimary),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Chemistry',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 350,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Price for 2 classes")),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Input price' : null,
                              onChanged: (val) {
                                // tTimezone = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Price for 3 classes")),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Input price' : null,
                              onChanged: (val) {
                                // tTimezone = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 350,
                              height: 45,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(242, 242, 242, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text("Price for 5 classes")),
                          const Spacer(),
                          Container(
                            width: 100,
                            height: 45,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(242, 242, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Input price' : null,
                              onChanged: (val) {
                                // tTimezone = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 600,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 130,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorPrimary,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      onPressed: () {},
                      child: const Text('Update'),
                    ),
                  ),
                ),
              )
              ],
            ),
          )),
    );
  }
}
