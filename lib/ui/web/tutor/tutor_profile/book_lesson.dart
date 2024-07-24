// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constant.dart';
import '../../../../data_class/chatmessageclass.dart';
import '../../../../data_class/subject_class.dart';
import '../../../../data_class/voucherclass.dart';
import '../../../../services/bookingfunctions/addnewbooking.dart';
import '../../../../services/bookingfunctions/paymenttransactions.dart';
import '../../../../services/getmessages.dart';
import '../../../../services/getvouchers.dart';
import '../../../../utils/themes.dart';

class BookLesson extends StatefulWidget {
  final dynamic subject;
  final String noofclasses;
  final String studentdata;
  final dynamic tutordata;
  final List<dynamic> tutorteach;
  final String currentprice;
  const BookLesson(
      {super.key,
      required this.studentdata,
      required this.tutordata,
      required this.tutorteach,
      required this.subject,
      required this.noofclasses,
      required this.currentprice});

  @override
  State<BookLesson> createState() => _BookLessonState();
}

class _BookLessonState extends State<BookLesson> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // StreamProvider<List<StudentsList>>.value(
        //   value: DatabaseService(uid: '').enrolleelist,
        //   catchError: (context, error) {
        //     print('Error occurred: $error');
        //     return [];
        //   },
        //   initialData: const [],
        // ),
        StreamProvider<List<ChatMessage>>.value(
          value: GetMessageList(uid: widget.studentdata, role: 'student')
              .getmessageinfo,
          catchError: (context, error) {
            return [];
          },
          initialData: const [],
        ),
      ],
      child: BookLessonBody(
        studentdata: widget.studentdata,
        tutordata: widget.tutordata,
        tutorteach: widget.tutorteach,
        noofclasses: widget.noofclasses,
        subject: widget.subject,
        currentprice: widget.currentprice,
      ),
    );
  }
}

class BookLessonBody extends StatefulWidget {
  final dynamic subject;
  final String noofclasses;
  final String studentdata;
  final dynamic tutordata;
  final List<dynamic> tutorteach;
  final String currentprice;

  final book;
  const BookLessonBody(
      {super.key,
      this.book,
      required this.studentdata,
      required this.tutordata,
      required this.tutorteach,
      required this.subject,
      required this.noofclasses,
      required this.currentprice});

  @override
  State<BookLessonBody> createState() => _BookLessonBodyState();
}

class _BookLessonBodyState extends State<BookLessonBody> {
  final TextEditingController subjectnameController = TextEditingController();

  final TextEditingController numberofclassController = TextEditingController();
  final TextEditingController myMessage = TextEditingController();

  List<String> provided = [
    '4',
    '6',
    '7',
    '8',
    '9',
  ];
  List<String> subjects = [];
  final int startHour = 0;
  final int endHour = 24;
  String dateselected = '';
  bool transact = false;
  @override
  void initState() {
    super.initState();
    for (dynamic tutor in widget.tutorteach) {
      if (tutor is Map<String, dynamic> && tutor.containsKey('subjectname')) {
        subjects.add(tutor['subjectname']);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = Provider.of<VoucherProvider>(context, listen: false);
      notifier.fetchVouchers(widget.studentdata);
    });
  }

  List<Voucherclass> selectedVouhers = [];
  double totalVoucher = 0.0;
  double totalVat = 0.0;
  double totalPayment = 0.0;
  double totalOrder = 0.0;
  bool voucheropen = false;
  List<String> extractDocumentIds(List<Voucherclass> docs) {
    List<String> documentIds = [];

    for (var doc in docs) {
      documentIds.add(doc.docID);
    }

    return documentIds;
  }

  @override
  Widget build(BuildContext context) {
    final subjectlist = Provider.of<List<Subjects>>(context);
    if (selectedVouhers.isEmpty) {
      totalVat = double.parse(
          (double.parse(widget.currentprice) * .12).toStringAsFixed(2));
      totalOrder = double.parse(widget.currentprice) + totalVat;

      totalPayment =
          double.parse((totalOrder - totalVoucher).toStringAsFixed(2));
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Stack(
        children: [
          SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                    maxHeight: 790,
                    minHeight: 620,
                    minWidth: 450,
                    maxWidth: 450),
                child: SizedBox(
                  height: voucheropen ? 770 : 620,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 430,
                        height: 100,
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/5836.png',
                                width: 200.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Flexible(
                              flex: 10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Payment Area',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: kColorGrey),
                                  ),
                                  Text(
                                    'This area will be updated for payment area just a sample.',
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        color: kColorGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: kColorGrey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kColorPrimary),
                      ),
                      const SizedBox(height: 16),
                      SummaryItem(
                        title: 'Subject Name',
                        amount: widget.subject,
                      ),
                      SummaryItem(
                        title: 'Number of Classes',
                        amount: widget.noofclasses,
                      ),
                      SummaryItem(
                        title: 'Price',
                        amount: '\$${widget.currentprice}',
                      ),
                      // SummaryItem(
                      //   title: 'Charge',
                      //   amount: '\$0.00',
                      // ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      SummaryItem(
                        title: 'Class Price',
                        amount: '\$${widget.currentprice}',
                        titleStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kColorGrey),
                        amountStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SummaryItem(
                        title: 'VAT',
                        amount: '+ \$$totalVat',
                      ),
                      const Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      SummaryItem(
                        title: 'Order Price',
                        amount: '\$$totalOrder',
                        titleStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kColorGrey),
                        amountStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ExpansionTile(
                              clipBehavior: Clip.hardEdge,
                              trailing: const Icon(
                                Icons.receipt_long_outlined,
                                color: kColorPrimary,
                              ),
                              onExpansionChanged: (value) {
                                if (value == true) {
                                  setState(() {
                                    voucheropen = value;
                                  });
                                } else {
                                  Future.delayed(
                                      const Duration(milliseconds: 200), () {
                                    setState(() {
                                      voucheropen = value;
                                    });
                                  });
                                }
                              },
                              textColor: kColorLight,
                              title: const Text(
                                'Select Voucher',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kColorGrey),
                              ),
                              children: <Widget>[
                                Consumer<VoucherProvider>(
                                    builder: (context, voucherProvider, child) {
                                  if (voucherProvider.vouchers.isEmpty) {
                                    const SizedBox(
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          'No available voucher.',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red),
                                        ),
                                      ),
                                    );
                                  }
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        kBorderRadius * 2),
                                    child: SizedBox(
                                        height: 150,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount:
                                                voucherProvider.vouchers.length,
                                            itemBuilder: (context, index) {
                                              final document = voucherProvider
                                                  .vouchers[index];
                                              return Card(
                                                elevation: 4,
                                                child: CheckboxListTile(
                                                  value: selectedVouhers
                                                      .contains(document),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (selectedVouhers
                                                          .contains(document)) {
                                                        selectedVouhers
                                                            .remove(document);
                                                      } else {
                                                        final tempAmount =
                                                            totalVoucher =
                                                                selectedVouhers
                                                                        .fold(
                                                                      0.0,
                                                                      (double sum,
                                                                              item) =>
                                                                          sum +
                                                                          (item.amount)
                                                                              .toDouble(),
                                                                    ) +
                                                                    document
                                                                        .amount;
                                                        if (tempAmount >
                                                            double.parse(widget
                                                                .currentprice)) {
                                                          CoolAlert.show(
                                                            context: context,
                                                            width: 200,
                                                            type: CoolAlertType
                                                                .error,
                                                            title: '',
                                                            text:
                                                                'Cannot select voucher. Total voucher is morethan the value of order price.',
                                                          );
                                                        } else {
                                                          selectedVouhers
                                                              .add(document);
                                                        }
                                                      }

                                                      totalVoucher =
                                                          selectedVouhers.fold(
                                                        0.0,
                                                        (double sum, item) =>
                                                            sum +
                                                            (item.amount)
                                                                .toDouble(),
                                                      );

                                                      totalOrder = double.parse(
                                                              widget
                                                                  .currentprice) +
                                                          totalVat;

                                                      totalPayment = double
                                                          .parse((totalOrder -
                                                                  totalVoucher)
                                                              .toStringAsFixed(
                                                                  2));
                                                    });
                                                  },
                                                  title: Text(
                                                    document.voucherName,
                                                    style: const TextStyle(
                                                        color: kColorPrimary,
                                                        fontSize: 16),
                                                  ),
                                                  subtitle: Text(
                                                    '\$${document.amount.toString()}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  selectedTileColor:
                                                      kColorLight,
                                                ),
                                              );
                                            })),
                                  );
                                })
                              ],
                            ),
                          ),
                          const Spacer(),
                          Center(
                              child: Text(
                                  '- \$${totalVoucher.toStringAsFixed(2)}'))
                        ],
                      ),

                      const Divider(
                        height: 20,
                        thickness: 1,
                      ),
                      SummaryItem(
                        title: 'To Pay',
                        amount: '\$$totalPayment',
                        titleStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kColorGrey),
                        amountStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 250,
                          // decoration: const BoxDecoration(
                          //   shape: BoxShape.rectangle,
                          //   color: kColorLight,
                          //   borderRadius: BorderRadius.all(Radius.circular(20)),
                          // ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                transact = true;
                              });
                              Subjects subjectid = subjectlist.firstWhere(
                                (element) =>
                                    element.subjectName == widget.subject,
                              );
                              List<String> idList = [
                                widget.tutordata['userId'],
                                widget.studentdata,
                              ];
                              BookingResult result = await addNewBooking(
                                  widget.tutordata['userId'],
                                  widget.studentdata,
                                  myMessage.text,
                                  subjectid.subjectId,
                                  int.parse(widget.noofclasses),
                                  idList,
                                  double.parse(widget.currentprice));
                              if (result.status == 'success') {
                                setState(() {
                                  transact = false;
                                  Navigator.of(context).pop();
                                  CoolAlert.show(
                                    context: context,
                                    width: 200,
                                    type: CoolAlertType.success,
                                    title: 'Payment Successful',
                                    text: 'You can view the class in Classes!',
                                  ).then(
                                    (value) {
                                      addTransactionInFirestore(
                                          result.classId,
                                          int.parse(widget.noofclasses),
                                          double.parse(widget.currentprice));
                                      addPaymentHistory(
                                          result.classId,
                                          int.parse(widget.noofclasses),
                                          double.parse(widget.currentprice),
                                          extractDocumentIds(selectedVouhers),
                                          totalVoucher,
                                          totalVat,
                                          '001',
                                          widget.studentdata,
                                          result.classReference,
                                          totalPayment);
                                    },
                                  );
                                });
                              } else {
                                setState(() {
                                  transact = false;
                                });
                                CoolAlert.show(
                                  context: context,
                                  width: 200,
                                  type: CoolAlertType.error,
                                  title: '',
                                  text: result.toString(),
                                  backgroundColor: Colors.black,
                                );
                              }
                            },
                            child: transact
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Text(
                                    'Pay Now',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: kColorPrimary, fontSize: 16),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(DateTime.now); // Close the dialog
              },
              child: const Icon(
                Icons.close,
                color: kColorGrey,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSequenceColor(int index) {
    int val = index % 4;
    if (val == 3) {
      return Colors.indigo;
    } else if (val == 2) {
      return Colors.grey;
    } else if (val == 1) {
      return Colors.redAccent;
    } else {
      return Colors.lightBlue;
    }
  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final String amount;
  final TextStyle? titleStyle;
  final TextStyle? amountStyle;

  SummaryItem({
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
