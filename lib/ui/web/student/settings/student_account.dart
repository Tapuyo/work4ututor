import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/user_class.dart';
import '../../../../services/getuser.dart';
import '../../../../utils/themes.dart';
import 'accountcancellation.dart';

class StudentAccounts extends StatefulWidget {
  final String uID;
  const StudentAccounts({super.key, required this.uID});

  @override
  State<StudentAccounts> createState() => _StudentAccountsState();
}

class _StudentAccountsState extends State<StudentAccounts> {
  //controllers
  TextEditingController conpassword = TextEditingController();
  TextEditingController conconfirmpassword = TextEditingController();
  TextEditingController connewpassword = TextEditingController();
  TextEditingController conemailadd = TextEditingController();
  List<String> languages = [];

  //obscuretext
  bool obscurrent = true;
  bool obsnewpass = true;
  bool obsconfirm = true;

  @override
  Widget build(BuildContext context) {
    final userinfodata = Provider.of<List<UserData>>(context);
    Size size = MediaQuery.of(context).size;

    if (userinfodata.isNotEmpty) {
      final userdata = userinfodata.first;
      conemailadd.text = userdata.email;
      conpassword.text = '';

      return Padding(
        padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
        child: Container(
          alignment: Alignment.topCenter,
          width: size.width - 320,
          height: size.height - 75,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: size.width - 320,
                    padding: const EdgeInsets.only(left: 200, right: 200),
                    child: Row(
                      children: [
                        const Text(
                          "Account Information",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Align(
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
                              onPressed: () {
                                accountCancelationDialog(context);
                              },
                              child: const Text(
                                'Cancel Account',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: size.width - 320,
                    padding: const EdgeInsets.only(left: 200, right: 200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 380,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration:
                                  const BoxDecoration(color: kColorPrimary),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Email Address',
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
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 380,
                                height: 50,
                                child: TextField(
                                  controller: conemailadd,
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLines: null,
                                  expands: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Email',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: 380,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration:
                                  const BoxDecoration(color: kColorPrimary),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'New Password',
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
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 380,
                                height: 50,
                                child: TextField(
                                  controller: connewpassword,
                                  obscureText: obsnewpass,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: '**********',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obsnewpass = !obsnewpass;
                                          });
                                        },
                                        icon: Icon(
                                          obsnewpass
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 380,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration:
                                  const BoxDecoration(color: kColorPrimary),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Current Password',
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
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 380,
                                height: 50,
                                child: TextField(
                                  controller: conpassword,
                                  obscureText: obscurrent,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: '**********',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obscurrent = !obscurrent;
                                          });
                                        },
                                        icon: Icon(
                                          obscurrent
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: 380,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              decoration:
                                  const BoxDecoration(color: kColorPrimary),
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Confirm New Password',
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
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 380,
                                height: 50,
                                child: TextField(
                                  controller: conconfirmpassword,
                                  obscureText: obsconfirm,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: '********',
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obsconfirm = !obsconfirm;
                                          });
                                        },
                                        icon: Icon(
                                          obsconfirm
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 200, right: 200, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
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
                              onPressed: () {
                                updateEmailAndPassword(
                                    conemailadd.text, connewpassword.text);
                              },
                              child: const Text('Update'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.topCenter,
        width: size.width - 320,
        height: size.height - 75,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
