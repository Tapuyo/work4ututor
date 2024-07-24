import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../../data_class/atmclass.dart';
import '../../../../utils/themes.dart';

class PaymentsHistory extends StatefulWidget {
  final String uID;
  const PaymentsHistory({super.key, required this.uID});

  @override
  State<PaymentsHistory> createState() => _PaymentsHistorysState();
}

List<ATMCard> _cards = [
  ATMCard(
    cardNumber: "**** **** **** 1234",
    cardHolderName: "John Doe",
    expirationDate: "12/23",
    bankName: "Bank of America",
    cardType: "Visa",
  ),
  ATMCard(
    cardNumber: "**** **** **** 5678",
    cardHolderName: "Jane Smith",
    expirationDate: "06/24",
    bankName: "Chase",
    cardType: "Mastercard",
  ),
];
List<Map<String, dynamic>> withdrawals = [
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'Success',
    'invoice': '0011235',
  },
  {
    'id': 2,
    'date': '2022-05-01',
    'amount': 50.0,
    'status': 'Success',
    'invoice': '0011234',
  },
  {
    'id': 3,
    'date': '2022-05-02',
    'amount': 75.0,
    'status': 'Failed',
    'invoice': '0011233',
  },
];

class _PaymentsHistorysState extends State<PaymentsHistory> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
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
        padding: const EdgeInsets.only(left: 100, right: 100, top: 20),
        child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: ScrollController(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: 50,
                  //   width: 400,
                  //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  //   decoration: const BoxDecoration(
                  //       color: kColorPrimary,
                  //       borderRadius: BorderRadius.all(Radius.circular(20))),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Row(
                  //       children: const [
                  //         Text(
                  //           'Total Paid',
                  //           style: TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.normal,
                  //               color: Colors.white),
                  //         ),
                  //         Spacer(),
                  //         Text(
                  //           '\$ 1023.00',
                  //           style: TextStyle(
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.white),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
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
                            'Accounts',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: kColorPrimary),
                          ),
                          const SizedBox(
                            width: 5,
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
                              onPressed: () {},
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
                  Container(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _cards.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Colors.blue
                                    : Colors.redAccent,
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
                                        Text(
                                          _cards[index].cardType,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _cards[index].bankName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        ListTile(
                                          leading:
                                              const Icon(Icons.credit_card),
                                          title: Text(_cards[index].cardNumber),
                                          subtitle: Text(
                                              _cards[index].cardHolderName),
                                          trailing: Text(
                                              _cards[index].expirationDate),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 500,
                    width: size.width,
                    child: SingleChildScrollView(
                      child: DataTable(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        columnSpacing: 100,
                        showBottomBorder: true,
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.grey[100]!),
                        border: const TableBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        headingRowHeight: 50,
                        headingTextStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: kColorPrimary),
                        columns: const [
                          DataColumn(
                              label: Text('Transaction',
                                  style: TextStyle(color: kColorPrimary))),
                          DataColumn(
                              label: Text('Invoice No.',
                                  style: TextStyle(color: kColorPrimary))),
                          DataColumn(
                              label: Text('Date',
                                  style: TextStyle(color: kColorPrimary))),
                          DataColumn(
                              label: Text('Amount',
                                  style: TextStyle(color: kColorPrimary))),
                          DataColumn(
                              label: Text('Status',
                                  style: TextStyle(color: kColorPrimary))),
                        ],
                        rows: withdrawals.map((withdrawal) {
                          final status = withdrawal['status'];
                          final statusColor =
                              status == 'Success' ? Colors.green : Colors.red;
                          return DataRow(cells: [
                            DataCell(Text('${withdrawal['id']}',
                                style: const TextStyle(color: kColorGrey))),
                            DataCell(Text('${withdrawal['invoice']}',
                                style: const TextStyle(color: kColorGrey))),
                            DataCell(Text('${withdrawal['date']}',
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
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class WithdrawalDataSource extends DataTableSource {
  final List<Map<String, dynamic>> withdrawals;

  WithdrawalDataSource(this.withdrawals);

  @override
  DataRow getRow(int index) {
    final withdrawal = withdrawals[index];
    final status = withdrawal['status'];
    final statusColor = status == 'Success' ? Colors.green : Colors.red;
    return DataRow(cells: [
      DataCell(Text(
        '${withdrawal['id']}',
        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        '${withdrawal['invoice']}',
        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        '${withdrawal['date']}',
        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      )),
      DataCell(Text(
        '\$${withdrawal['amount']}',
        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      )),
      DataCell(
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: statusColor),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text(
            status,
            style: TextStyle(
                color: statusColor,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => withdrawals.length;

  @override
  int get selectedRowCount => 0;
}
