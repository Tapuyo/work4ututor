// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:work4ututor/services/gettutorpayments.dart';
import 'package:work4ututor/ui/web/tutor/settings/payments_withdrawals.dart';
import '../../../../provider/datarangenotifier.dart';
import '../../../../provider/selectnotifier.dart';
import '../../../../services/addfinishedclass.dart';
import '../../../../utils/themes.dart'; // Add this import for date formatting
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding JSON

class DisbursementTable extends StatelessWidget {
  final String userID;
  DisbursementTable({super.key, required this.userID});

  // Future<void> _selectDateRange(BuildContext context) async {
  //   final DateTime now = DateTime.now();
  //   final DateTimeRange? picked = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime(now.year - 5),
  //     lastDate: DateTime(now.year + 5),
  //     initialDateRange: context.read<DateRangeNotifier>().selectedDateRange ??
  //         DateTimeRange(start: now, end: now),
  //     builder: (BuildContext context, Widget? child) {
  //       return  ConstrainedBox(
  //                 constraints: const BoxConstraints(
  //                   maxWidth: 400.0,
  //                 ),
  //         child: child!,
  //       );
  //     },
  //   );

  //   if (picked != null &&
  //       picked != context.read<DateRangeNotifier>().selectedDateRange) {
  //     context.read<DateRangeNotifier>().updateDateRange(picked);
  //   }
  // }
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerDialog(
          initialDateRange:
              context.read<DateRangeNotifier>().selectedDateRange ??
                  DateTimeRange(start: now, end: now),
          onDateRangeSelected: (DateTimeRange selectedRange) {
            context.read<DateRangeNotifier>().updateDateRange(selectedRange);
          },
        );
      },
    );

    if (picked != null &&
        picked != context.read<DateRangeNotifier>().selectedDateRange) {
      context.read<DateRangeNotifier>().updateDateRange(picked);
    }
  }

  void showAddBankWithdrawalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AccounntUseDialog();
      },
    );
  }

  final List<int> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    Provider.of<ClaimableNotifier>(context, listen: false)
        .getClaims(userID, 'tutor');

    return Consumer<DateRangeNotifier>(
        builder: (context, dateRangeNotifier, child) {
      return Consumer<ClaimableNotifier>(
        builder: (context, claimDetailsNotifier, child) {
          if (claimDetailsNotifier.claims.isEmpty) {
            return const Center(child: Text('No Details!'));
          } else {
            final List<Map<String, dynamic>> withdrawals =
                claimDetailsNotifier.claims;
            // Filter withdrawals based on the selected date range
            final filteredWithdrawals = dateRangeNotifier.selectedDateRange ==
                    null
                ? withdrawals
                : withdrawals.where((withdrawal) {
                    final date = DateFormat('yyyy-MM-dd')
                        .parse(withdrawal['dateclassFinished']);
                    return date.isAfter(
                            dateRangeNotifier.selectedDateRange!.start) &&
                        date.isBefore(dateRangeNotifier.selectedDateRange!.end);
                  }).toList();

            return _buildWithdrawalTable(context, filteredWithdrawals,
                dateRangeNotifier.selectedDateRange);
          }
        },
      );
    });
  }

  Widget _buildWithdrawalTable(BuildContext context,
      List<Map<String, dynamic>> withdrawals, DateTimeRange? daterange) {
    // Sorting withdrawals by date
    final sortedWithdrawals = List<Map<String, dynamic>>.from(withdrawals);
    sortedWithdrawals.sort((a, b) {
      final dateFormat = DateFormat(
          'yyyy-MM-dd'); // Update this format based on your date format
      final dateA = dateFormat.parse(a['dateclassFinished']);
      final dateB = dateFormat.parse(b['dateclassFinished']);
      return dateA.compareTo(dateB);
    });
    Size size = MediaQuery.of(context).size;
    final dataSource = DisbursementTableDataSource(
      context,
      sortedWithdrawals,
      _selectedItems,
      Provider.of<SelectionNotifier>(context, listen: false),
    );

    return Consumer<SelectionNotifier>(
        builder: (context, selectionNotifier, child) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
            color: Colors.white,
            height: 520,
            width: size.width,
            child: PaginatedDataTable(
              arrowHeadColor: kColorPrimary,
              header: const Text(
                'Disbursements',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: kColorPrimary,
                ),
              ),
              actions: [
                Container(
                  height: 40,
                  width: 150,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: selectionNotifier.selectedItems.isEmpty
                          ? Colors.grey.shade100
                          : Colors.greenAccent,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
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
                    onPressed: selectionNotifier.selectedItems.isEmpty
                        ? null
                        : () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AccounntUseDialog();
                              },
                            );
                          },
                    icon: const Icon(Icons.monetization_on_outlined,
                        size: 16, color: kColorPrimary),
                    label: const Text(
                      'Claim Now',
                      style: TextStyle(fontSize: 14, color: kColorPrimary),
                    ),
                  ),
                )
              ],
              columns: const [
                // DataColumn(
                //     label: Text('', style: TextStyle(color: kColorPrimary))),
                // DataColumn(
                //     label: Text('Disburse ID',
                //         style: TextStyle(color: kColorPrimary))),
                DataColumn(
                    label: Text('Class Id',
                        style: TextStyle(color: kColorPrimary))),
                DataColumn(
                    label: Text('Class Completed',
                        style: TextStyle(color: kColorPrimary))),
                DataColumn(
                    label:
                        Text('Amount', style: TextStyle(color: kColorPrimary))),
                DataColumn(
                    label: Text('Disbursed',
                        style: TextStyle(color: kColorPrimary))),

                DataColumn(
                    label: Text('Tutor CCR',
                        style: TextStyle(color: kColorPrimary))),
                DataColumn(
                    label: Text('Student CCR',
                        style: TextStyle(color: kColorPrimary))),
                DataColumn(
                    label:
                        Text('Status', style: TextStyle(color: kColorPrimary))),
              ],
              source: dataSource,
              rowsPerPage: 7,
              columnSpacing: 20,
              horizontalMargin: 11,
              showCheckboxColumn: true,
              onSelectAll: (value) {
                if (Provider.of<SelectionNotifier>(context, listen: false)
                    .selectedItems
                    .isNotEmpty) {
                  Provider.of<SelectionNotifier>(context, listen: false)
                      .clearSelection();
                } else {
                  Provider.of<SelectionNotifier>(context, listen: false)
                      .selectAll(sortedWithdrawals);
                }
              },
            ),
          ),
        ),
      );
    });
  }
}

class DisbursementTableDataSource extends DataTableSource {
  final List<Map<String, dynamic>> withdrawals;
  final List<int> selectedItems;

  final BuildContext context;
  final SelectionNotifier selectionNotifier;

  // final List<bool> selectedRows;

  DisbursementTableDataSource(this.context, this.withdrawals,
      this.selectedItems, this.selectionNotifier);

  // void selectAll(bool? checked) {
  //   for (var i = 0; i < selectedRows.length; i++) {
  //     selectedRows[i] = checked ?? false;
  //   }
  //   notifyListeners();
  // }
  Future<String?> getToken(String username, String password) async {
    final url = Uri.parse('http://localhost:21021/api/TokenAuth/Authenticate');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'usernameOrEmailAddress': username,
      'password': password,
      'rememberClient': true
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        return responseBody['result']['accessToken'];
      } else {
        print('Failed to authenticate. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }

  @override
  DataRow getRow(int index) {
    final withdrawal = withdrawals[index];
    final status = withdrawal['disburseStatus'];
    final statusColor = status == 'Success' ? Colors.green : Colors.red;

    return DataRow(
      selected: Provider.of<SelectionNotifier>(context).isSelected(withdrawal),
      onSelectChanged: (selected) {
        if (selected != null) {
          if (withdrawal['disburseStatus'] != 'Success' &&
                  withdrawal['adminReady'] == false &&
                  withdrawal['tutorStatus'] == 'Completed' &&
                  DateTime.now()
                          .difference(DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                              .parse(withdrawal['dateclassFinished']))
                          .inHours >
                      72 ||
              withdrawal['disburseStatus'] != 'Success' &&
                  withdrawal['adminReady'] == false &&
                  withdrawal['tutorStatus'] == 'Completed' &&
                  withdrawal['studentStatus'] == 'Completed') {
            Provider.of<SelectionNotifier>(context, listen: false)
                .toggleSelection(withdrawal);
          } else {}
        }
      },
      cells: [
        // DataCell(Consumer<SelectionNotifier>(
        //     builder: (context, selectionNotifier, child) {
        //   return withdrawals[index]['adminReady'] == false ||
        //           withdrawal['tutorStatus'] == 'Completed' &&
        //               DateTime.now()
        //                       .difference(DateFormat('yyyy-MM-dd')
        //                           .parse(withdrawal['dateclassFinished']))
        //                       .inDays >
        //                   0 ||
        //           withdrawal['tutorStatus'] == 'Completed' &&
        //               withdrawal['studentStatus'] == 'Completed'
        //       ? Checkbox(
        //           value: selectionNotifier.selectedItems.contains(index),
        //           onChanged: (value) {
        //             selectionNotifier.toggleSelection(index);
        //           },
        //         )
        //       : const Center(
        //           child: Text('-', style: TextStyle(color: kColorGrey)));
        // })),
        // DataCell(Text('${withdrawal['disburseId']}',
        //     style: const TextStyle(color: kColorGrey))),
        DataCell(Text('CLASS-${withdrawal['classId']}',
            style: const TextStyle(color: kColorGrey))),
        DataCell(Text(
            DateFormat("MMMM d, yyyy 'at' h:mm:ss a").format(
                DateFormat('yyyy-MM-dd HH:mm:ss.SSS')
                    .parse(withdrawal['dateclassFinished'])),
            style: const TextStyle(color: kColorGrey))),
        DataCell(Text('\$${withdrawal['disburseAmount']}',
            style: const TextStyle(color: kColorGrey))),
        DataCell(withdrawal['dateDisburse'] != null
            ? Text(
                DateFormat('MMMM dd, yyyy').format(
                    DateFormat('yyyy-MM-dd').parse(withdrawal['dateDisburse'])),
                style: const TextStyle(color: kColorGrey))
            : const Text('-', style: TextStyle(color: kColorGrey))),

        const DataCell(Text('Recieved', style: TextStyle(color: kColorGrey))),
        DataCell(Text(
            DateTime.now()
                            .difference(DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                                .parse(withdrawal['dateclassFinished']))
                            .inHours >
                        72 &&
                    withdrawal['studentStatus'] == 'Pending'
                ? 'Not Recieved'
                : withdrawal['studentStatus'] == 'Completed'
                    ? 'Recieved'
                    : '${withdrawal['studentStatus']}',
            style: const TextStyle(color: kColorGrey))),
        DataCell(withdrawal['adminReady'] == false &&
                    withdrawal['tutorStatus'] == 'Completed' &&
                    DateTime.now()
                            .difference(DateFormat("yyyy-MM-dd HH:mm:ss.SSS")
                                .parse(withdrawal['dateclassFinished']))
                            .inHours >
                        72 ||
                withdrawal['adminReady'] == false &&
                    withdrawal['tutorStatus'] == 'Completed' &&
                    withdrawal['studentStatus'] == 'Completed'
            ? Container(
                height: 30,
                width: 80,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Claimable',
                  style: TextStyle(color: kColorLight),
                ),
              )
            : withdrawal['disburseStatus'] == 'Success'
                ? Container(
                    height: 30,
                    width: 80,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Claimed',
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                : withdrawal['disburseStatus'] == 'Pending'
                    ? Container(
                        height: 30,
                        width: 80,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Processing',
                          style: TextStyle(color: Colors.amberAccent),
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          String? data = await getToken('admin', '123qwe');
                          print(data);
                          // Future<void> fetchData() async {
                          // const url =
                          //     'http://180.191.42.44/accapi/api/services/app/CollectionService/GetCollection'; // Replace with your API endpoint
                          // final headers = {
                          //   'Content-Type': 'application/json',
                          //   'Authorization':
                          //       'Bearer wNYmO41/48SHNstaLVXxHCCre29BZQl1NhC6NM3R3rzpXtPQxVzH6jEzA/QhXFN5tu6Fk7pO53uppm1mVXMZgxbyRVz26dnepi/FyB6axBY+6gq1GL+uRQgoiFUCjRN2p8w6LevViwKlHyWZZJZO1DGVSjAi1m2U+og9pkHw9/QR4Nl/DPnoP9JYDMpZ1zxx09u6s0GZ9/Q5Sjk+L0UfcSCbl38X8he5w9UIn/Hvxh7ysM1CiPLsoOwtbiieSRVmrmt0JjnipAn4/K283F8GrGwzwgehWsqefmUnM0ckMwP9ZAdwQxWDhxv0IqNw4tDhwUYs/1SYdYozdNzgByhgNOBPzQDObNLlWc4vV5VMOiYZmN7CVtsiggbIwTzBxCrV6Al+zX/ZmD7qz8tKJxf8WTXZKLKYVAdLkCeGRR0fTHhv5E54oZ3Idit9u2SPA/KtxvigVBgknOY1xAp8TijHac5A8r8Pb7n7Tg+iW4HX4bnIC95zjoVGzmnyrCdlcJfWswtDkPCESnPIXOmj1CrqE3+tGfJMoYzqhKmfTZwcsARFkPE7fTY7rb2DaOowVhjz50zqgSeLiBdBv1X494P1gOwGoTQc4m6FMnjSHzE+mSiR/TV34sAZJKyRZrt8dball2d1LZA/LEuBVhNUJdu4J5u+OnEZ2yJKgY3T4dq6esIJyoy+noSihiXyH3ESI0ZzOLNeQqvXLonJOem9ZlCVjpwjY5tm4NE7Wxowfrx/gX8QgFdYQkV0/Ngyib+z7LuT8dsXBSd7RV+s13LGGxINdgI96LAbBYaR3iYABEopIfoGDbqHK7xAx+DNxbZZ/Ch4OuHaGeYzSxGbjm+jl6Rz+ddF6FNgsjAIHj5A7qsW7QyTH/HV4usW8QaLwc59K2vZeRcngDi5wK7tD+tD9i206EK9zCJfPkF+HsVIN6BuaWAvAg+d11T9SOKTdkfTe6+nNTOiADHrJPkx5pyCYX5EHTQnZvly/2q7vmnVsp0VbPI5xG6oPC9Xh+P7n6QsSn6Kx+TqhPtvbumEIAZKwutCJXVggJerXs5Qf+tJTREyKS19gK2gHee7VAVvc2lxro8ftkuMFoZLLOpSjIbLqUIE/ezG6kF0+tHoiDMQFw/vV1kg9msChLEmixcM6mHvFlO5ND34hWGzbN/+GRD+a3TaSdeERclM4glKFv+v5qjcwMQ='
                          // };

                          // try {
                          //   final response = await http.get(
                          //     Uri.parse(url),
                          //     headers: headers,
                          //   );

                          //   if (response.statusCode == 200) {
                          //     // If the server returns an OK response, parse the JSON
                          //     final data = json.decode(response.body);
                          //     print(data); // Handle your data here
                          //   } else {
                          //     // If the server did not return an OK response, throw an exception
                          //     throw Exception('Failed to load data');
                          //   }
                          // } catch (error) {
                          //   print('Error fetching data: $error');
                          // }
                          // }
                        },
                        child: Container(
                          height: 30,
                          width: 80,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '-',
                            style: TextStyle(color: statusColor),
                          ),
                        ),
                      )),
      ],
    );
  }

  // void _showDetailsPopup(
  //     BuildContext context, Map<String, dynamic> withdrawal) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: ConstrainedBox(
  //           constraints: const BoxConstraints(
  //             maxWidth: 650.0,
  //           ),
  //           child: Container(
  //             padding: const EdgeInsets.all(5),
  //             width: double.maxFinite,
  //             height: 520,
  //             child: ScrollConfiguration(
  //               behavior:
  //                   ScrollConfiguration.of(context).copyWith(scrollbars: true),
  //               child: SingleChildScrollView(
  //                 controller: ScrollController(),
  //                 child: Padding(
  //                   padding: const EdgeInsets.only(right: 20.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       const Text(
  //                         'Sales Invoice',
  //                         style: TextStyle(
  //                             fontSize: 24, fontWeight: FontWeight.bold),
  //                       ),
  //                       const SizedBox(height: 20),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: const [
  //                               Text('From:'),
  //                               Text('WORK4UTUTOR'),
  //                               Text('WORK4UTUTOR Ph.'),
  //                             ],
  //                           ),
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: const [
  //                               Text('To:'),
  //                               Text('Customer Name'),
  //                               Text('Customer Address'),
  //                               Text('City, State, Zip Code'),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 20),
  //                       const Divider(),
  //                       const SizedBox(height: 20),
  //                       const Text(
  //                         'Invoice Details',
  //                         style: TextStyle(
  //                             fontSize: 18, fontWeight: FontWeight.bold),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text('Invoice No.: ${withdrawal['invoice']}'),
  //                       Text('Date: ${withdrawal['date']}'),
  //                       const SizedBox(height: 20),
  //                       const Text(
  //                         'Transaction Details',
  //                         style: TextStyle(
  //                             fontSize: 18, fontWeight: FontWeight.bold),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Text('Transaction ID: ${withdrawal['id']}'),
  //                       Text('Amount: \$${withdrawal['amount']}'),
  //                       Text('Status: ${withdrawal['status']}'),
  //                       const SizedBox(height: 20),
  //                       const Divider(),
  //                       const SizedBox(height: 20),
  //                       const Text(
  //                         'Thank you for your business!',
  //                         style: TextStyle(fontSize: 16),
  //                       ),
  //                       const SizedBox(height: 10),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.end,
  //                         children: [
  //                           Tooltip(
  //                             message: 'Download Invoice',
  //                             child: Container(
  //                               width: 120,
  //                               height: 30,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 // color: Colors
  //                                 //     .green
  //                                 //     .shade400,
  //                               ),
  //                               child: TextButton.icon(
  //                                 style: TextButton.styleFrom(
  //                                   padding: const EdgeInsets.all(10),
  //                                   alignment: Alignment.center,
  //                                   foregroundColor:
  //                                       const Color.fromRGBO(1, 118, 132, 1),
  //                                   // backgroundColor:
  //                                   //     Colors
  //                                   //         .green
  //                                   //         .shade200,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(24.0),
  //                                   ),
  //                                   // ignore: prefer_const_constructors
  //                                   textStyle: const TextStyle(
  //                                     color: Colors.deepPurple,
  //                                     fontSize: 12,
  //                                     fontStyle: FontStyle.normal,
  //                                     decoration: TextDecoration.none,
  //                                   ),
  //                                 ),
  //                                 onPressed: () {
  //                                   _captureAndDownloadPdf(withdrawal);
  //                                   Navigator.of(context).pop();
  //                                 },
  //                                 icon: const Icon(Icons.download,
  //                                     size: 16, color: kColorPrimary),
  //                                 label: const Text(
  //                                   'Download',
  //                                   style: TextStyle(
  //                                       fontSize: 14, color: kColorPrimary),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Tooltip(
  //                             message: 'Close',
  //                             child: Container(
  //                               width: 90,
  //                               height: 30,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 // color: Colors
  //                                 //     .green
  //                                 //     .shade400,
  //                               ),
  //                               child: TextButton.icon(
  //                                 style: TextButton.styleFrom(
  //                                   padding: const EdgeInsets.all(10),
  //                                   alignment: Alignment.center,
  //                                   foregroundColor:
  //                                       const Color.fromRGBO(1, 118, 132, 1),
  //                                   // backgroundColor:
  //                                   //     Colors
  //                                   //         .green
  //                                   //         .shade200,
  //                                   shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(24.0),
  //                                   ),
  //                                   // ignore: prefer_const_constructors
  //                                   textStyle: const TextStyle(
  //                                     color: Colors.deepPurple,
  //                                     fontSize: 12,
  //                                     fontStyle: FontStyle.normal,
  //                                     decoration: TextDecoration.none,
  //                                   ),
  //                                 ),
  //                                 onPressed: () {
  //                                   Navigator.of(context).pop();
  //                                 },
  //                                 icon: const Icon(Icons.close,
  //                                     size: 16, color: kColorDarkRed),
  //                                 label: const Text(
  //                                   'Close',
  //                                   style: TextStyle(
  //                                       fontSize: 14, color: kColorDarkRed),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _captureAndDownloadPdf(Map<String, dynamic> withdrawal) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Container(
          padding: const pw.EdgeInsets.all(32),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Sales Invoice',
                style:
                    pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('From:'),
                      pw.Text('WORK4UTUTOR'),
                      pw.Text('WORK4UTUTOR Ph.'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('To:'),
                      pw.Text('Customer Name'),
                      pw.Text('Customer Address'),
                      pw.Text('City, State, Zip Code'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(
                'Invoice Details',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Invoice No.: ${withdrawal['invoice']}'),
              pw.Text('Date: ${withdrawal['date']}'),
              pw.SizedBox(height: 20),
              pw.Text(
                'Transaction Details',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Transaction ID: ${withdrawal['id']}'),
              pw.Text('Amount: \$${withdrawal['amount']}'),
              pw.Text('Status: ${withdrawal['status']}'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Text(
                'Thank you for your business!',
                style: const pw.TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );

    final Uint8List pdfData = await pdf.save();

    // Trigger the download
    final blob = html.Blob([pdfData], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'transaction_${withdrawal['id']}.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => withdrawals.length;

  @override
  int get selectedRowCount =>
      Provider.of<SelectionNotifier>(context).selectedItems.length;
}

class DateRangePickerDialog extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final Function(DateTimeRange)? onDateRangeSelected;

  const DateRangePickerDialog({
    Key? key,
    this.initialDateRange,
    this.onDateRangeSelected,
  }) : super(key: key);

  @override
  _DateRangePickerDialogState createState() => _DateRangePickerDialogState();
}

class _DateRangePickerDialogState extends State<DateRangePickerDialog> {
  late DateTimeRange _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.initialDateRange ??
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 200,
        height: 300,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CalendarDatePicker(
                initialDate: _selectedDateRange.start,
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
                onDateChanged: (DateTime? newDate) {
                  if (newDate != null) {
                    setState(() {
                      _selectedDateRange = DateTimeRange(
                          start: newDate, end: _selectedDateRange.end);
                    });
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.onDateRangeSelected != null) {
                  widget.onDateRangeSelected!(_selectedDateRange);
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}

class AccounntUseDialog extends StatefulWidget {
  const AccounntUseDialog({
    super.key,
  });

  @override
  _AccounntUseDialogState createState() => _AccounntUseDialogState();
}

class _AccounntUseDialogState extends State<AccounntUseDialog> {
  final _formKey = GlobalKey<FormState>();
  String emailaccount = '';
  String password = '';
  String? selectedCard;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerAll = ScrollController();
  List<Map<String, dynamic>> items = [];
  double totalAmount = 0.0;
  double disburseAmount = 0.0;
  double commisionFee = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.credit_card,
            color: kColorPrimary,
          ),
          Text(
            'Withdrawal Account',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: kColorPrimary,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        controller: _scrollControllerAll,
        child: SizedBox(
          width: 450,
          height: 450,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('tutorAccounts')
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: kColorPrimary,
                              ));
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              final List<Map<String, dynamic>> accounts =
                                  snapshot.data!.docs.map((doc) {
                                final Timestamp timestamp =
                                    doc['dateRegistered'];
                                final DateTime date = timestamp.toDate();

                                return {
                                  'id': doc.id,
                                  'accountHolder': doc['accountHolder'] ?? '',
                                  'dateRegistered': date.toString(),
                                  'accountNumber': doc['accountNumber'] ?? '',
                                  'address': doc['address'] ?? '',
                                  'bankName': doc['bankName'] ?? '',
                                  'ifscCode': doc['ifscCode'] ?? '',
                                  'tutorId': doc['tutorId'] ?? '',
                                };
                              }).toList();
                              return DropdownButton<String>(
                                value: selectedCard,
                                hint: const Text("Select a account"),
                                items: accounts.map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> card) {
                                  return DropdownMenuItem<String>(
                                    value: card['accountNumber'],
                                    child: Text(obscureAccountNumber(
                                        card['accountNumber'])),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    final selected = accounts.firstWhere(
                                      (element) =>
                                          element['accountNumber'] == newValue,
                                    );
                                    String dateString = selected[
                                        'dateRegistered']; // Replace with your actual string
                                    DateTime date = DateTime.parse(dateString);
                                    int hourDifference =
                                        calculateHourDifference(date);
                                    if (hourDifference < 1) {
                                      CoolAlert.show(
                                          context: context,
                                          width: 200,
                                          type: CoolAlertType.error,
                                          title: '',
                                          text:
                                              'Account still onhold, please go back later!',
                                          backgroundColor: kColorGrey);
                                    } else {
                                      setState(() {
                                        selectedCard = newValue;
                                      });
                                    }
                                  }
                                },
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Withdrawal Summary',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kColorPrimary),
              ),
              Consumer<SelectionNotifier>(
                  builder: (context, selectionNotifier, child) {
                items = selectionNotifier.selectedItems;
                final totalAmountDisburse =
                    selectionNotifier.selectedItems.fold(
                  0.0,
                  (double sum, item) =>
                      sum + (item['disburseAmount'] as num).toDouble(),
                );
                final twelvePercent = totalAmountDisburse * 0.12;
                final totaldisburse = totalAmountDisburse - twelvePercent;
                totalAmount = totalAmountDisburse;
                disburseAmount = totaldisburse;
                commisionFee = twelvePercent;

                return Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility:
                            true, // Ensure the scrollbar is always visible
                        thickness:
                            6.0, // Customize the thickness of the scrollbar
                        radius: const Radius.circular(10.0),
                        child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: selectionNotifier.selectedItems.length,
                            padding: const EdgeInsets.only(right: 10),
                            itemBuilder: (BuildContext context, int index) {
                              final data =
                                  selectionNotifier.selectedItems[index];
                              return Align(
                                alignment: Alignment.centerRight,
                                child: SummaryItem(
                                  title: 'CLASS-${data['classId']}',
                                  amount: '\$${data['disburseAmount']}',
                                ),
                              );
                            }),
                      ),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 1,
                    ),
                    SummaryItem(
                      title: 'Total',
                      amount: '\$${totalAmountDisburse.toStringAsFixed(2)}',
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kColorGrey),
                      amountStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SummaryItem(
                      title: 'Commision Fee(12%)',
                      amount: '- \$${twelvePercent.toStringAsFixed(2)}',
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kColorGrey),
                      amountStyle: const TextStyle(
                        fontSize: 16,
                        color: kCalendarColorB,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 1,
                    ),
                    SummaryItem(
                      title: 'Amount',
                      amount: '\$${totaldisburse.toStringAsFixed(2)}',
                      titleStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kColorGrey),
                      amountStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(
                height: 5,
              ),
              const Text(
                  'Note: Please be informed that a withdrawal fee will be deducted from the total amount disbursed.')
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: 'Claim',
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
                      // addClassFinished();
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print(
                            '$items, $selectedCard, ${disburseAmount.toStringAsFixed(2)}, ${commisionFee.toStringAsFixed(2)}, ${totalAmount.toStringAsFixed(2)}');
                      }

                      dynamic result = await updateAndAddToClaimHistory(
                          items,
                          selectedCard!,
                          double.parse(disburseAmount.toStringAsFixed(2)),
                          double.parse(commisionFee.toStringAsFixed(2)),
                          double.parse(totalAmount.toStringAsFixed(2)));
                      if (result.toString() == 'Success') {
                        Provider.of<SelectionNotifier>(context, listen: false)
                            .clearSelection();
                        Navigator.of(context).pop();
                        CoolAlert.show(
                          context: context,
                          width: 200,
                          type: CoolAlertType.success,
                          title: '',
                          text: "Claim Requested!",
                        );
                      } else {
                        CoolAlert.show(
                            context: context,
                            width: 200,
                            type: CoolAlertType.error,
                            title: '',
                            text: 'Error Claiming!',
                            backgroundColor: kColorGrey);
                      }
                    },
                    icon: const Icon(Icons.add_card_outlined,
                        size: 16, color: kColorPrimary),
                    label: const Text(
                      'Claim Now',
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

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMMM d, y ' 'at ' 'h:mm:ss a z');
    return formatter.format(dateTime);
  }

  int calculateHourDifference(DateTime date) {
    final DateTime now = DateTime.now();
    return now.difference(date).inHours;
  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final String amount;
  final TextStyle? titleStyle;
  final TextStyle? amountStyle;

  const SummaryItem({
    super.key,
    required this.title,
    required this.amount,
    this.titleStyle,
    this.amountStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ?? const TextStyle(fontSize: 16),
          ),
          Text(
            amount,
            style: amountStyle ?? const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
