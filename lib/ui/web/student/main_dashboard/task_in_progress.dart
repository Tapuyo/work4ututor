import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constant/constant.dart';
import '../../../../data_class/voucherclass.dart';
import '../../../../services/getvouchers.dart';
import '../../../../utils/themes.dart';
import 'coupon.dart';

class VoucherData extends StatefulWidget {
  VoucherData({
    Key? key,
  }) : super(key: key);

  @override
  State<VoucherData> createState() => _VoucherDataState();
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
class _VoucherDataState extends State<VoucherData> {
  @override
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
                physics: const BouncingScrollPhysics(),
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
