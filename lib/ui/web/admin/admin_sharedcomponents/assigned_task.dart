import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wokr4ututor/constant/constant.dart';
import 'package:wokr4ututor/shared_components/alphacode3.dart';
import 'package:wokr4ututor/ui/web/admin/admin_sharedcomponents/header_text.dart';

import '../../../../utils/themes.dart';

class AssignTask extends StatefulWidget {
  // final Map<String, dynamic> onDataReceived;

  const AssignTask({Key? key}) : super(key: key);
  @override
  State<AssignTask> createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask> {
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
    return Form(
      key: adminformkey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kColorPrimary,
          title: const HeaderText('Add New Task'),
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
                  const HeaderText('Task Name'),
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
                        hintStyle: TextStyle(color: Colors.black),
                        hintText: 'Taskname',
                        border: InputBorder.none,
                      ),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter Taskname' : null,
                      onChanged: (val) {
                        adminname = val;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const HeaderText('Task Type'),
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
                        hintText: 'Type of Task',
                        border: InputBorder.none,
                      ),
                      validator: (val) =>
                          val!.isEmpty ? '-----' : null,
                      onChanged: (val) {
                        adminposition = val;
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
