// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import '../../../../provider/datarangenotifier.dart';
import '../../../../services/getPaymentHistory.dart';
import '../../../../utils/themes.dart'; // Add this import for date formatting

class WithdrawalTable extends StatelessWidget {
    final String userID;

  WithdrawalTable({super.key, required this.userID});
  DateTimeRange? _selectedDateRange;

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

  @override
  Widget build(BuildContext context) {
        Provider.of<PaymentHistoryNotifier>(context, listen: false)
        .getHistory(userID, '');
    return Consumer<DateRangeNotifier>(
        builder: (context, dateRangeNotifier, child) {
      return Consumer<PaymentHistoryNotifier>(
        builder: (context, historydetails, child) {
          if (historydetails.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.history_edu_outlined,
                    size: 50,
                    color: kColorPrimary,
                  ),
                  Text(
                    'History is empty.',
                    style: TextStyle(
                      fontSize: 24,
                      color: kCalendarColorB,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            );
          } else {
            final List<Map<String, dynamic>> withdrawals =
                historydetails.history;
            // Filter withdrawals based on the selected date range
            final filteredWithdrawals = dateRangeNotifier.selectedDateRange ==
                    null
                ? withdrawals
                : withdrawals.where((withdrawal) {
                    final date =
                        DateFormat('yyyy-MM-dd').parse(withdrawal['date']);
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
      final dateA = dateFormat.parse(a['date']);
      final dateB = dateFormat.parse(b['date']);
      return dateA.compareTo(dateB);
    });
    Size size = MediaQuery.of(context).size;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: SizedBox(
          height: 520,
          width: size.width,
          child: PaginatedDataTable(
            arrowHeadColor: kColorPrimary,
            // ignore: prefer_const_constructors
            header: Row(
              children: [
                const Text(
                  'Payments History',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: kColorPrimary,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _selectDateRange(context),
                  child: Text(
                    daterange == null
                        ? 'Select Date Range'
                        : '${DateFormat('MMMM dd, yyyy').format(daterange.start)} - ${DateFormat('MMMM dd, yyyy').format(daterange.end)}',
                    style: const TextStyle(
                        color: kColorPrimary, fontWeight: FontWeight.w400),
                  ),
                ),
                Visibility(
                  visible: daterange != null,
                  child: Tooltip(
                    message: 'Clear Range',
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
                          Provider.of<DateRangeNotifier>(context, listen: false)
                              .clearDateRange();
                        },
                        icon: const Icon(Icons.close,
                            size: 16, color: kColorDarkRed),
                        label: const Text(
                          'Clear',
                          style: TextStyle(fontSize: 14, color: kColorDarkRed),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

            columns: const [
              DataColumn(
                  label: Text('Transaction',
                      style: TextStyle(color: kColorPrimary))),
              DataColumn(
                  label: Text('Invoice No.',
                      style: TextStyle(color: kColorPrimary))),
              DataColumn(
                  label: Text('Date', style: TextStyle(color: kColorPrimary))),
              DataColumn(
                  label:
                      Text('Amount', style: TextStyle(color: kColorPrimary))),
              DataColumn(
                  label:
                      Text('Status', style: TextStyle(color: kColorPrimary))),
            ],
            source: WithdrawalDataSource(context, sortedWithdrawals),
            rowsPerPage: 7,
            columnSpacing: 20,
            horizontalMargin: 11,
            showCheckboxColumn: false,
          ),
        ),
      ),
    );
  }
}

class WithdrawalDataSource extends DataTableSource {
  final List<Map<String, dynamic>> withdrawals;
  final BuildContext context;

  WithdrawalDataSource(this.context, this.withdrawals);

  @override
  DataRow getRow(int index) {
    final withdrawal = withdrawals[index];
    final status = withdrawal['status'];
    final statusColor = status == 'Success' ? Colors.green : Colors.red;
    return DataRow(
      cells: [
        DataCell(Text('${withdrawal['id']}',
            style: const TextStyle(color: kColorGrey))),
        DataCell(Text('${withdrawal['invoice']}',
            style: const TextStyle(color: kColorGrey))),
        DataCell(Text(
            DateFormat('MMMM dd, yyyy')
                .format(DateFormat('yyyy-MM-dd').parse(withdrawal['date'])),
            style: const TextStyle(color: kColorGrey))),
        DataCell(Text('\$${withdrawal['amount']}',
            style: const TextStyle(color: kColorGrey))),
        DataCell(
          Container(
            height: 30,
            width: 75,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: Text(
              status,
              style: TextStyle(color: statusColor),
            ),
          ),
        ),
      ],
      onSelectChanged: (selected) {
        if (selected == true) {
          _showDetailsPopup(context, withdrawal);
        }
      },
    );
  }

  void _showDetailsPopup(
      BuildContext context, Map<String, dynamic> withdrawal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 650.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              width: double.maxFinite,
              height: 520,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: true),
                child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Sales Invoice',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('From:'),
                                Text('WORK4UTUTOR'),
                                Text('WORK4UTUTOR Ph.'),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('To:'),
                                Text('Customer Name'),
                                Text('Customer Address'),
                                Text('City, State, Zip Code'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        const Text(
                          'Invoice Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text('Invoice No.: ${withdrawal['invoice']}'),
                        Text('Date: ${withdrawal['date']}'),
                        const SizedBox(height: 20),
                        const Text(
                          'Transaction Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text('Transaction ID: ${withdrawal['id']}'),
                        Text('Amount: \$${withdrawal['amount']}'),
                        Text('Status: ${withdrawal['status']}'),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                        const Text(
                          'Thank you for your business!',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Tooltip(
                              message: 'Download Invoice',
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
                                    foregroundColor:
                                        const Color.fromRGBO(1, 118, 132, 1),
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
                                    _captureAndDownloadPdf(withdrawal);
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.download,
                                      size: 16, color: kColorPrimary),
                                  label: const Text(
                                    'Download',
                                    style: TextStyle(
                                        fontSize: 14, color: kColorPrimary),
                                  ),
                                ),
                              ),
                            ),
                            Tooltip(
                              message: 'Close',
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
                                    foregroundColor:
                                        const Color.fromRGBO(1, 118, 132, 1),
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
                                  icon: const Icon(Icons.close,
                                      size: 16, color: kColorDarkRed),
                                  label: const Text(
                                    'Close',
                                    style: TextStyle(
                                        fontSize: 14, color: kColorDarkRed),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
  int get selectedRowCount => 0;
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
