// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work4ututor/alertbox/confirmationdialog.dart';

import '../../../../services/addcarddetails.dart';
import '../../../../services/getcarddetails.dart';
import '../../../../utils/themes.dart';
import 'confirmtoupdate.dart';
import 'disbursement.dart';

class PaymentsWithdrwals extends StatefulWidget {
  final String userID;
  const PaymentsWithdrwals({super.key, required this.userID});

  @override
  State<PaymentsWithdrwals> createState() => _PaymentsWithdrwalsState();
}

Color _getColorForStatus(String status) {
  if (status == 'Processed') {
    return Colors.green;
  } else if (status == 'Pending') {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}

String obscureAccountNumber(String accountNumber) {
  if (accountNumber.length <= 4) {
    return accountNumber; // If the account number is too short, don't obscure it
  }
  // Replace all but the last 4 characters with asterisks
  return '*' * (accountNumber.length - 4) +
      accountNumber.substring(accountNumber.length - 4);
}

void showAddBankDetailsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ConfirmationDialog(
        accountNumber: '',
        address: '',
        bankName: '',
        ifscCode: '',
        name: '',
        tutorId: '',
      );
    },
  );
}

class _PaymentsWithdrwalsState extends State<PaymentsWithdrwals> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = Provider.of<CardDetailsNotifier>(context, listen: false);
      notifier.getCards(widget.userID);
    });
    // _fetchData();
    // _pageController = PageController(initialPage: _currentPageIndex);
    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   if (_currentPageIndex < gifUrls.length - 1) {
    //     _currentPageIndex++;
    //   } else {
    //     _currentPageIndex = 0;
    //   }
    //   _pageController.animateToPage(
    //     _currentPageIndex,
    //     duration: const Duration(milliseconds: 500),
    //     curve: Curves.easeInOut,
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(          color: Colors.white,

      margin: EdgeInsets.zero,
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), // Adjust the radius as needed
          topRight: Radius.circular(10.0), // Adjust the radius as needed
        ),
      ),
      child: Container(
        alignment: Alignment.topLeft,
        width: size.width - 320,
        height: size.height - 75,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     Container(
                  //       height: 50,
                  //       width: 300,
                  //       padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //       decoration: const BoxDecoration(
                  //           color: kColorPrimary,
                  //           borderRadius: BorderRadius.all(Radius.circular(20))),
                  //       child: Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Row(
                  //           children: const [
                  //             Text.rich(TextSpan(children: [
                  //               TextSpan(
                  //                 text: 'Earnigs On Hold',
                  //                 style: TextStyle(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white),
                  //               ),
                  //               TextSpan(
                  //                 text: '\nWORK4UTUTOR FEES ALREADY APPLIED',
                  //                 style: TextStyle(
                  //                     fontSize: 8,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white),
                  //               ),
                  //             ])),
                  //             Spacer(),
                  //             Text(
                  //               '\$ 523.00',
                  //               style: TextStyle(
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.white),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     const Spacer(),
                  //     Container(
                  //       height: 50,
                  //       width: 300,
                  //       padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //       decoration: const BoxDecoration(
                  //           color: kColorPrimary,
                  //           borderRadius: BorderRadius.all(Radius.circular(20))),
                  //       child: Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Row(
                  //           children: const [
                  //             Text.rich(TextSpan(children: [
                  //               TextSpan(
                  //                 text: 'Earnigs Recieved',
                  //                 style: TextStyle(
                  //                     fontSize: 18,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white),
                  //               ),
                  //               TextSpan(
                  //                 text: '\nWORK4UTUTOR FEES ALREADY APPLIED',
                  //                 style: TextStyle(
                  //                     fontSize: 8,
                  //                     fontWeight: FontWeight.bold,
                  //                     color: Colors.white),
                  //               ),
                  //             ])),
                  //             Spacer(),
                  //             Text(
                  //               '\$ 500.00',
                  //               style: TextStyle(
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.white),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     const Spacer(),
                  //     Container(
                  //       height: 50,
                  //       width: 300,
                  //       padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //       decoration: const BoxDecoration(
                  //           color: kColorPrimary,
                  //           borderRadius: BorderRadius.all(Radius.circular(20))),
                  //       child: Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Row(
                  //           children: const [
                  //             Text(
                  //               'Total Earnigs',
                  //               style: TextStyle(
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.normal,
                  //                   color: Colors.white),
                  //             ),
                  //             Spacer(),
                  //             Text(
                  //               '\$ 1023.00',
                  //               style: TextStyle(
                  //                   fontSize: 18,
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.white),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  Container(
                    height: 50,
                    width: 300,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text(
                            'Account',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: kColorPrimary,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 120,
                            height: 30,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              onPressed: () {
                                confirmtoUpdate(context, widget.userID);
                                // _showAddBankDetailsDialog(context);
                              },
                              child: const Text(
                                'Add New',
                                style: TextStyle(color: kColorPrimary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 200,
                    child: Consumer<CardDetailsNotifier>(
                        builder: (context, cardDetailsNotifier, child) {
                      if (cardDetailsNotifier.cards.isEmpty) {
                        return const Center(child: Text('No Cards Added!'));
                      } else {
                        final List<Map<String, dynamic>> accounts =
                            cardDetailsNotifier.cards;
                      
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: accounts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Card(
                                            color: Colors.white,

                                  margin: EdgeInsets.zero,
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                      color: kColorLight,
                                    ),
                                    height: 160,
                                    width: 320,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Text(
                                              //   _cards[index].cardType,
                                              //   style: const TextStyle(
                                              //       color: Colors.white,
                                              //       fontSize: 24,
                                              //       fontWeight: FontWeight.bold),
                                              // ),
                                              Text(
                                                accounts[index]['bankName'],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.credit_card),
                                                title: Text(
                                                    obscureAccountNumber(
                                                        accounts[index]
                                                            ['accountNumber'])),
                                                subtitle: Text(accounts[index]
                                                    ['accountHolder']),
                                                trailing: Text(DateFormat(
                                                        'MM/dd')
                                                    .format(DateTime.parse(
                                                        accounts[index][
                                                            'dateRegistered']))),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    }),
                  ),

                  Container(
                    color: Colors.white,
                    child: DisbursementTable(userID: widget.userID,)),
                ],
              ),
            )),
      ),
    );
  }
}

class AddBankDetailsDialog extends StatefulWidget {
  final String tutorId;
  const AddBankDetailsDialog({super.key, required this.tutorId});

  @override
  _AddBankDetailsDialogState createState() => _AddBankDetailsDialogState();
}

class _AddBankDetailsDialogState extends State<AddBankDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  String bankName = '';
  String accountNumber = '';
  String ifscCode = '';
  String address = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Bank Details',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: kColorPrimary,
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Bank Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bank name required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  bankName = value!;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'IBAN/Account Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'IBAN/Account number required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  accountNumber = value!;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'SWIFT Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'SWIFT code required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  ifscCode = value!;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Account Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account holder name required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Please enter the Address';
                //   }
                //   return null;
                // },
                onSaved: (value) {
                  address = value!;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: 'Save Account',
                child: Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color: Colors
                    //     .green
                    //     .shade400,
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      foregroundColor: const Color.fromRGBO(1, 118, 132, 1),
                      // backgroundColor:
                      //     Colors
                      //         .green
                      //         .shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      // ignore: prefer_const_constructors
                      textStyle: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmationDialog(
                              accountNumber: accountNumber,
                              address: address,
                              bankName: bankName,
                              ifscCode: ifscCode,
                              name: name,
                              tutorId: widget.tutorId,
                            );
                          },
                        );
                      }
                    },
                    icon: const Icon(Icons.add_card_outlined,
                        size: 16, color: kColorPrimary),
                    label: const Text(
                      'Save Account',
                      style: TextStyle(fontSize: 14, color: kColorPrimary),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: 'Cancel',
                child: Container(
                  width: 90,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                   
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      foregroundColor: const Color.fromRGBO(1, 118, 132, 1),
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon:
                        const Icon(Icons.close, size: 16, color: kColorDarkRed),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14, color: kColorDarkRed),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ConfirmationDialog extends StatefulWidget {
  final String tutorId;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String address;
  final String name;
  const ConfirmationDialog(
      {super.key,
      required this.tutorId,
      required this.bankName,
      required this.accountNumber,
      required this.ifscCode,
      required this.address,
      required this.name});

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  final _formKey = GlobalKey<FormState>();
  String emailaccount = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_person_outlined,
            color: kColorPrimary,
          ),
          Text(
            'Verification',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: kColorPrimary,
            ),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email account'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email account required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  emailaccount = value!;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required.';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: 'Verify',
                child: Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color: Colors
                    //     .green
                    //     .shade400,
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      foregroundColor: const Color.fromRGBO(1, 118, 132, 1),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      // ignore: prefer_const_constructors
                      textStyle: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String? result = await authenticateAndAddCardDetails(
                          tutorID: widget.tutorId,
                          bankName: widget.bankName,
                          cardHolderName: widget.name,
                          cardNumber: widget.accountNumber,
                          ifscCode: widget.ifscCode,
                          address: widget.address,
                          context: context,
                          email: emailaccount,
                          password: password,
                        );
                        if (result != null) {
                          if (result == 'success') {
                            Navigator.of(context).pop();
                            showConfirmationDialog(context, '', "Account Added", () {
                              Navigator.of(context).pop();
                            },);
                            CoolAlert.show(
                              context: context,
                              width: 200,
                              type: CoolAlertType.success,
                              title: '',
                              text: "Account Added",
                            );
                          } else {
                            CoolAlert.show(
                                context: context,
                                width: 200,
                                type: CoolAlertType.error,
                                title: '',
                                text: 'Failed to autenticate, check inputs!',
                                backgroundColor: kColorGrey);
                          }
                        } else {
                          CoolAlert.show(
                              context: context,
                              width: 200,
                              type: CoolAlertType.error,
                              title: '',
                              text: 'Failed to autenthicate, check inputs!',
                              backgroundColor: kColorGrey);
                        }
                      }
                    },
                    icon: const Icon(Icons.add_card_outlined,
                        size: 16, color: kColorPrimary),
                    label: const Text(
                      'Verify',
                      style: TextStyle(fontSize: 14, color: kColorPrimary),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: 'Cancel',
                child: Container(
                  width: 90,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    // color: Colors
                    //     .green
                    //     .shade400,
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      foregroundColor: const Color.fromRGBO(1, 118, 132, 1),
                      // backgroundColor:
                      //     Colors
                      //         .green
                      //         .shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      // ignore: prefer_const_constructors
                      textStyle: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon:
                        const Icon(Icons.close, size: 16, color: kColorDarkRed),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14, color: kColorDarkRed),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
