import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/services/send_email.dart';
import 'package:wokr4ututor/shared_components/alphacode3.dart';
import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/header_text.dart';
import 'package:wokr4ututor/ui/web/admin/executive_dashboard.dart';

import '../../../../utils/themes.dart';

class Newadmin extends StatefulWidget {
  // final Map<String, dynamic> onDataReceived;

  const Newadmin({Key? key}) : super(key: key);
  @override
  State<Newadmin> createState() => _NewadminState();
}

class _NewadminState extends State<Newadmin> {
  final adminformkey = GlobalKey<FormState>();

  String adminname = '';
  String adminlastname = '';
  String contact = '';
  String address = '';
  String personalemail = '';
  String adminID = '';
  String password = '';
  String adminposition = '';

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    return Form(
      key: adminformkey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kColorPrimary,
          title: const HeaderText('Add New Admin'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 50.0,
                right: 50,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderText('Complete Name'),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        height: 45,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 159, 159,
                                159), // Set your desired border color here
                            width: .5, // Set the border width
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black),
                            hintText: 'Firstname',
                            border: InputBorder.none,
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter firstname' : null,
                          onChanged: (val) {
                            adminname = val;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Container(
                        width: 148,
                        height: 45,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 159, 159,
                                159), // Set your desired border color here
                            width: .5, // Set the border width
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black),
                            hintText: 'Lastname',
                            border: InputBorder.none,
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter lastname' : null,
                          onChanged: (val) {
                            adminlastname = val;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const HeaderText('Address'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    height: 45,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 159, 159,
                            159), // Set your desired border color here
                        width: .5, // Set the border width
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CountryPickerDropdown(
                      onValuePicked: (Country country) {
                        final alpha3Code = getAlpha3Code(country.name);
                        Random random = Random();
                        int randomNumber = random.nextInt(1000000) + 1;
                        String currentyear =
                            DateFormat('yyyy').format(DateTime.now());
                        //todo please replace the random number with legnth of students enrolled
                        setState(() {
                          // tutorIDNumber =
                          //     'TTR$alpha3Code$currentyear$randomNumber';
                          address = country.name;
                        });
                      },
                      itemBuilder: (Country country) {
                        return Row(
                          children: <Widget>[
                            Expanded(child: Text(country.name)),
                          ],
                        );
                      },
                      itemHeight: 50,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                    // country.name
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const HeaderText('Position'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    height: 45,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 159, 159,
                            159), // Set your desired border color here
                        width: .5, // Set the border width
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Select position',
                        border: InputBorder.none,
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Select position' : null,
                      onChanged: (val) {
                        adminposition = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const HeaderText('Contact'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    height: 45,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 159, 159,
                            159), // Set your desired border color here
                        width: .5, // Set the border width
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: '+000000000',
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter contact number' : null,
                      onChanged: (val) {
                        contact = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const HeaderText('Personal email'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    height: 45,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 159, 159,
                            159), // Set your desired border color here
                        width: .5, // Set the border width
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: 'Enter email',
                      ),
                      validator: (val) => val!.isEmpty ? 'Enter email' : null,
                      onChanged: (val) {
                        personalemail = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    width: 300,
                    height: 65,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.black),
                        backgroundColor: kColorPrimary,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Color.fromRGBO(
                                1, 118, 132, 1), // your color here
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        int length = controller.adminsList.value.length + 1;
                        adminID = 'WORK4U$length';
                        password = 'work4u2023';
                        if (adminformkey.currentState!.validate()) {
                          try {
                            await AdminService.saveAdminData(
                              adminname: adminname,
                              contact: contact,
                              address: address,
                              personalemail: personalemail,
                              adminID: adminID,
                              password: password,
                              adminposition: adminposition,
                              adminlastname: adminlastname,
                            );
                            SendEmailtoadmin.sendMail(
                              email: personalemail,
                              message:
                                  'Your UserID: $adminID and Password: $password',
                              name: 'MJ Amles',
                            );

                            print('Admin data saved successfully');
                          } catch (error) {
                            print('Error saving admin data: $error');
                          }
                        }
                      },
                      child: const Text(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                        'Save ',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminService {
  static Future<void> saveAdminData({
    required String adminname,
    required String adminlastname,
    required String contact,
    required String address,
    required String personalemail,
    required String adminID,
    required String password,
    required String adminposition,
  }) async {
    CollectionReference adminsCollection =
        FirebaseFirestore.instance.collection('admin');

    await adminsCollection.add({
      'adminFirstName': adminname,
      'adminMiddleName': 'N/A',
      'adminLastName': adminlastname,
      'contactnumber': contact,
      'address': address,
      'adminemail': personalemail,
      'adminID': adminID,
      'password': password,
      'adminposition': adminposition,
      'dateRegisterd': DateTime.now(),
    });
  }
}
