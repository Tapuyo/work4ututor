import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data_class/voucherclass.dart';
import '../../../../services/getvouchers.dart';
import '../../../../utils/themes.dart';
import 'coupon.dart';

class TaskInProgress extends StatefulWidget {
  TaskInProgress({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskInProgress> createState() => _TaskInProgressState();
}
Stream<List<Voucherclass>> get voucherlist {
  return FirebaseFirestore.instance
        .collection('vouchers')
      .doc('XuQyf7S8gCOJBu6gTIb0')
      .collection('myvouchers')
      .snapshots()
      .map(_getVouchers);
}

List<Voucherclass> _getVouchers(QuerySnapshot snapshot) {
  return snapshot.docs.map((cardtask) {
    return Voucherclass(
      amount: cardtask['amount'] ?? '',
      expiryDate: cardtask['expiryDate'] ?? '',
      startDate: cardtask['startDate'] ?? '',
      voucherName: cardtask['vName'] ?? '',
      vstatus: cardtask['vstatus'] ?? '',
    );
  }).toList();
}
class _TaskInProgressState extends State<TaskInProgress> {
  // final List<CardTaskData> data;
  final CollectionReference<Map<String, dynamic>> _mainCollection =
      FirebaseFirestore.instance.collection('vouchers');

  @override
  // Widget build(BuildContext context) {
  //   return StreamBuilder<List<Voucherclass>>(
  //       stream: voucherlist,
  //       builder: (context, snapshot) {
  //       //    if (snapshot.connectionState == ConnectionState.waiting) {
  //       //   return Text('Loading...');
  //       // }
  //       if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       }
  //       final vouchers = snapshot.data ?? [];
  //         if (snapshot.hasData) {
  //           return ClipRRect(
  //             borderRadius: BorderRadius.circular(kBorderRadius * 2),
  //             child: SizedBox(
  //               height: 250,
  //               child: ListView.builder(
  //                   shrinkWrap: true,
  //                   scrollDirection: Axis.horizontal,
  //                   physics: const NeverScrollableScrollPhysics(),
  //                   itemCount: vouchers.length,
  //                   itemBuilder: (context, index) {
  //                     final mainDocument = vouchers[index];
  //                     debugPrint(mainDocument.toString());
  //                     return Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: kSpacing / 2),
  //                       child: Text(mainDocument.voucherName),
  //                     );
  //                   }),
  //             ),
  //           );
  //         } else {
  //           return const Center(
  //             child: Text(
  //               'No available voucher.',
  //               style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
  //             ),
  //           );
  //         }
  //       });
  //   //  : const  Center(child:  Text('No available voucher.', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),),);
  // }
  Widget build(BuildContext context) {
    final data = Provider.of<List<Voucherclass>>(context);
    if (data.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadius * 2),
        child: SizedBox(
            height: 250,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final document = data[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kSpacing / 2),
                    child: CardTask(
                      data: document,
                      primary: _getSequenceColor(index),
                      onPrimary: Colors.white,
                    ),
                  );
                })),
      );
    } else {
      return const Center(
        child: Text(
          'No available voucher.',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
        ),
      );
    }
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
