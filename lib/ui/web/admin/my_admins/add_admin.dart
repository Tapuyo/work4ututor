// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../services/send_email.dart';
import '../../../../utils/themes.dart';
import '../admin_sharedcomponents/header_text.dart';
import '../executive_dashboard.dart';
import 'admin_list.dart';

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
  String adminposition = 'Executive Admin';

  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2099),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('MMMM d, yyyy').format(selectedDate);
      });
    }
  }

  InputDecoration getInputDecoration() {
    // ignore: unnecessary_null_comparison
    if (selectedDate != null) {
      return const InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.calendar_today),
        labelText: null, // Set labelText to null when selectedDate is not empty
      );
    } else {
      return const InputDecoration(
        border: InputBorder.none,
        icon: Icon(Icons.calendar_today),
        labelText: "Enter Date",
      );
    }
  }

  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'PH');
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());
    List<AdminPositions> positionsList = controller.adminpositionlist.value;
    List<String> datalist = positionsList
        .where((item) => item.nameofposition != null)
        .map((item) => item.nameofposition)
        .toList();
    return Form(
      key: adminformkey,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Firstname',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                  const SizedBox(
                    height: 15,
                  ),
                  const HeaderText('Lastname'),
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
                  const SizedBox(
                    height: 15,
                  ),
                  const HeaderText('Date of Birth'),
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
                    child: TextField(
                        controller:
                            dateController, //editing controller of this TextField
                        decoration: getInputDecoration(),
                        readOnly: true, // when true user cannot edit text
                        onTap: () async {
                          _selectDate(context);
                        }),
                  ),
                  const HeaderText('Country'),
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
                        initialValue: 'PH',
                        itemBuilder: _buildDropdownItem,
                        sortComparator: (Country a, Country b) =>
                            a.isoCode.compareTo(b.isoCode),
                        onValuePicked: (Country country) {
                          print(country.name);
                          setState(() {
                            address = country.name;
                            phoneNumber = PhoneNumber(isoCode: country.isoCode);
                          });
                        },
                        isExpanded: true,
                      )
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
                    child: DropdownButton<String>(
                      value: adminposition, // Use the selectedValue variable
                      items: datalist.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      underline: Container(),
                      isExpanded: true,
                      onChanged: (newValue) {
                        // Update the selected value when it changes
                        setState(() {
                          adminposition = newValue!;
                        });
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
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          phoneNumber = number;
                          print(phoneNumber.phoneNumber);
                        });
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                      ),
                      ignoreBlank: false,
                      // autoValidateMode: AutovalidateMode.onUserInteraction,
                      inputDecoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      initialValue: phoneNumber,
                      textFieldController: phoneNumberController,
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
                        final currentContext = context;
                        adminID = 'WORK4U$length';
                        password = 'work4u2023';
                        if (adminformkey.currentState!.validate()) {
                          try {
                            await AdminService.saveAdminData(
                              adminname: adminname,
                              contact: phoneNumber.phoneNumber!,
                              address: address,
                              personalemail: personalemail,
                              adminID: adminID,
                              password: password,
                              adminposition: adminposition,
                              adminlastname: adminlastname,
                              dateofbirth: selectedDate,
                            );
                            // SendEmailtoadmin.sendMail(
                            //   email: personalemail,
                            //   message:
                            //       'Your UserID: $adminID and Password: $password',
                            //   name: 'MJ Amles',
                            // );
                            print('Admin data saved successfully');
                            CoolAlert.show(
                              context: currentContext,
                              type: CoolAlertType.success,
                              text: 'Admin Added Successfully!',
                              autoCloseDuration: const Duration(seconds: 3),
                            ).then((_) {
                              Navigator.of(context).pop();
                            });
                          } catch (error) {
                            print('Error saving admin data: $error');
                            CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: 'Oops...',
                              text: 'Sorry, something went wrong',
                              backgroundColor: Colors.black,
                            );
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

  Widget _buildDropdownItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(
            width: 8.0,
          ),
          Text(country.name),
        ],
      );
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
    required DateTime dateofbirth,
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
      'dateofbirth': dateofbirth,
      'adminID': adminID,
      'adminpassword': password,
      'adminposition': adminposition,
      'dateRegisterd': DateTime.now(),
      'adminstatus': 'Active',
    });
  }
   static Future<void> updateAdminData({
    required String adminId, 
   required String adminstatus,
  }) async {
    CollectionReference adminsCollection =
        FirebaseFirestore.instance.collection('admin');

    DocumentReference adminRef = adminsCollection.doc(adminId);

    Map<String, dynamic> dataToUpdate = {};
    if (adminstatus != null) dataToUpdate['adminstatus'] = adminstatus;

    await adminRef.update(dataToUpdate);
  }
}
