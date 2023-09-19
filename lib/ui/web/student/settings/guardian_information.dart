import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/studentinfoclass.dart';
import '../../../../services/getstudentinfo.dart';
import '../../../../utils/themes.dart';

class GuardianInfoSettings extends StatefulWidget {
  final String uID;
  const GuardianInfoSettings({super.key, required this.uID});

  @override
  State<GuardianInfoSettings> createState() => _GuardianInfoSettingsState();
}

//controllers
TextEditingController confirstname = TextEditingController();
TextEditingController conmiddlename = TextEditingController();
TextEditingController conlastname = TextEditingController();
TextEditingController conaddress = TextEditingController();
TextEditingController concountry = TextEditingController();
TextEditingController concontact = TextEditingController();
TextEditingController conemailadd = TextEditingController();

String uID = "Upload your ID";
bool selection1 = false;
bool selection2 = false;
bool selection3 = false;
bool selection4 = false;
bool selection5 = false;
TextEditingController _aboutmecontroller = TextEditingController();

class _GuardianInfoSettingsState extends State<GuardianInfoSettings> {
  @override
  Widget build(BuildContext context) {
    final guardianinfo = Provider.of<List<StudentGuardianClass>>(context);
    Size size = MediaQuery.of(context).size;
    if (guardianinfo.isNotEmpty) {
      final guardiandata = guardianinfo.first;
      confirstname.text = guardiandata.guardianFirstname;
      conmiddlename.text = guardiandata.guardianMiddlename;
      conlastname.text = guardiandata.guardianLastname;
      concountry.text = guardiandata.country;
      conaddress.text = guardiandata.address;
      conemailadd.text = guardiandata.email;
      concontact.text = guardiandata.contact;
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
                    height: 50,
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
                                  'Guardian Name',
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
                                  controller: confirstname,
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLines: null,
                                  expands: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'First Name',
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
                                  'Country of Residence',
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
                                  controller: concountry,
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLines: null,
                                  expands: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Country',
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
                                  'Guardian Last Name',
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
                                  controller: conlastname,
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLines: null,
                                  expands: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Last Name',
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
                                  'City/State',
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
                                  controller: conaddress,
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLines: null,
                                  expands: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'City/State',
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
                                  'Contact',
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
                                  controller: concontact,
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLines: null,
                                  expands: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Contact',
                                  ),
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
                                setState(() {
                                  if (conaddress.text.isNotEmpty ||
                                      concontact.text.isNotEmpty ||
                                      concountry.text.isNotEmpty ||
                                      conemailadd.text.isNotEmpty ||
                                      confirstname.text.isNotEmpty ||
                                      conlastname.text.isNotEmpty ||
                                      conmiddlename.text.isNotEmpty) {
                                    updateGuardianInfo(
                                        'XuQyf7S8gCOJBu6gTIb0',
                                        guardiandata.docID,
                                        confirstname.text,
                                        conmiddlename.text,
                                        conlastname.text,
                                        concontact.text,
                                        conemailadd.text,
                                        conaddress.text,
                                        concountry.text);
                                  } else {
                                    return;
                                  }
                                });
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
