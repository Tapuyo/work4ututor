import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/studentinofclass.dart';
import '../../../../data_class/voucherclass.dart';
import '../../../../utils/themes.dart';

class StudentInformation extends StatefulWidget {
  const StudentInformation({super.key});

  @override
  State<StudentInformation> createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
  //controllers
  TextEditingController confirstname = TextEditingController();
  TextEditingController conmiddlename = TextEditingController();
  TextEditingController conlastname = TextEditingController();
  TextEditingController conaddress = TextEditingController();
  TextEditingController concountry = TextEditingController();
  TextEditingController concontact = TextEditingController();
  TextEditingController conemailadd = TextEditingController();
  TextEditingController conemailacount = TextEditingController();
  TextEditingController conpassword = TextEditingController();
  TextEditingController connewpassword = TextEditingController();
  TextEditingController conconfirmpassword = TextEditingController();

  //obscuretext
  bool obscurrent = true;
  bool obsnewpass = true;
  bool obsconfirm = true;
  @override
  Widget build(BuildContext context) {
    final studentinfodata = Provider.of<List<StudentInfoClass>>(context);
    bool selection5 = false;
    const Color background = Color.fromRGBO(55, 116, 135, 1);
    const Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];

    const double fillPercent = 30; // fills 56.23% for container from bottom
    const double fillStop = (100 - fillPercent) / 100;
    const List<double> stops = [0.0, fillStop, fillStop, 1.0];
    Size size = MediaQuery.of(context).size;

    if (studentinfodata.isNotEmpty) {
      final studentdata = studentinfodata.first;
      confirstname.text = studentdata.studentFirstname;
      conmiddlename.text = studentdata.studentMiddlename;
      conlastname.text = studentdata.studentLastname;
      concountry.text = studentdata.country;
      List<String> languages = studentdata.languages;
      conaddress.text = studentdata.address;
      conemailadd.text = studentdata.emailadd;
      concontact.text = studentdata.contact;

      void deleteLanguage(String language) {
        if (languages.contains(language)) {
          languages.remove(language);
          print('$language deleted successfully!');
        } else {
          print('$language not found in the list.');
        }
      }

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
                  Container(
                    width: size.width - 320,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        stops: stops,
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(
                          flex: 10,
                          child: SingleChildScrollView(
                            controller: ScrollController(),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 200.0, right: 200, top: 20),
                                    child: Container(
                                      height: 250,
                                      width: 250,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.transparent,
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/sample.jpg'),
                                              fit: BoxFit.cover)),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: SizedBox(
                                          width: 250,
                                          height: 40,
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white60,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                            ),
                                            onPressed: () {},
                                            label: const Text(
                                              '',
                                              style: TextStyle(
                                                  color: kColorPrimary),
                                            ),
                                            icon: const Icon(
                                              Icons.camera_alt_outlined,
                                              size: 30,
                                              color: kColorPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                  'First Name',
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
                                    hintText: 'City/State',
                                  ),
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
                                    hintText: 'State',
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
                                  'Last Name',
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
                                  'Language',
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
                              width: 380,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: languages.length,
                                itemBuilder: (context, index) {
                                  final item = languages[index];

                                  return Dismissible(
                                    key: Key(item),
                                    onDismissed: (direction) {
                                      setState(() {
                                        deleteLanguage(item);
                                      });
                                    },
                                    background: Container(color: Colors.red),
                                    child: ListTile(
                                      title: Text(
                                        item,
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        tooltip: 'Remove this language',
                                        onPressed: () {
                                          setState(() {
                                            deleteLanguage(item);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 200,
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                  ),
                                  onPressed: () {
                                    print(languages.toString());
                                  },
                                  child: const Text(
                                    'Add more language',
                                    style: TextStyle(color: kColorPrimary),
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
                              onPressed: () {},
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
