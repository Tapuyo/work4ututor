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
      cardBackgroundImage:
          "https://cdn.pixabay.com/photo/2015/09/18/19/03/credit-card-948087_960_720.jpg"),
  ATMCard(
      cardNumber: "**** **** **** 5678",
      cardHolderName: "Jane Smith",
      expirationDate: "06/24",
      bankName: "Chase",
      cardType: "Mastercard",
      cardBackgroundImage:
          "https://cdn.pixabay.com/photo/2016/11/22/21/42/credit-card-1853120_960_720.jpg"),
];
List<Map<String, dynamic>> withdrawals = [
  {
    'id': 1,
    'date': '2022-04-29',
    'amount': 100.0,
    'status': 'paid',
  },
  {
    'id': 2,
    'date': '2022-05-01',
    'amount': 50.0,
    'status': 'padi',
  },
  {
    'id': 3,
    'date': '2022-05-02',
    'amount': 75.0,
    'status': 'paid',
  },
];

class _PaymentsHistorysState extends State<PaymentsHistory> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topLeft,
      width: size.width - 320,
      height: size.height - 75,
      padding: const EdgeInsets.only(left: 100, right: 100, top: 20),
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 400,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: const BoxDecoration(
                      color: kColorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: const [
                        Text(
                          'Total Paid',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        Spacer(),
                        Text(
                          '\$ 1023.00',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                                image: DecorationImage(
                                    image: NetworkImage(
                                        _cards[index].cardBackgroundImage),
                                    fit: BoxFit.cover)),
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
                                        leading: const Icon(Icons.credit_card),
                                        title: Text(_cards[index].cardNumber),
                                        subtitle:
                                            Text(_cards[index].cardHolderName),
                                        trailing:
                                            Text(_cards[index].expirationDate),
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
                Container(
                  height: 500,
                  child: ListView.builder(
                    itemCount: withdrawals.length,
                    itemBuilder: (BuildContext context, int index) {
                      final withdrawal = withdrawals[index];
                      return ListTile(
                        title: Text('Payment History #${withdrawal['id']}'),
                        subtitle: Text(
                            'Date: ${withdrawal['date']} | Amount: \$${withdrawal['amount']} | Status: ${withdrawal['status']}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
