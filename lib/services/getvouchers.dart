import 'package:cloud_firestore/cloud_firestore.dart';

import '../data_class/voucherclass.dart';

class GetVouchers {
  String uid;
  GetVouchers({required this.uid});

  Stream<List<Voucherclass>> get voucherlist {
    return FirebaseFirestore.instance
        .collection('vouchers')
        .doc(uid)
        .collection('myvouchers')
        .snapshots()
        .map(_getVoucher);
  }

  List<Voucherclass> _getVoucher(QuerySnapshot snapshot) {
    return snapshot.docs.map((cardtask) {
      return Voucherclass(
        amount: cardtask['amount'] ?? '',
        expiryDate: cardtask['expiryDate'].toDate() ?? '',
        startDate: cardtask['startDate'].toDate() ?? '',
        voucherName: cardtask['vName'] ?? '',
        vstatus: cardtask['vstatus'] ?? '',
      );
    }).toList();
  }

  void getUserBooks() async {
    await FirebaseFirestore.instance
        .collection('vouchers')
        .doc(uid)
        .collection("myvouchers")
        .get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            print(element.data());
          });
        });
        }
  //     // print("--------------------- Books ---------------------\n"
  //     //     "id: ${booksModel.bookID}\n"
  //     //     "name: ${booksModel.bookName}\n"
  //     //     "image: ${booksModel.bookImage}");
  //   });
  // }

  // Stream<QuerySnapshot> fetchSubcollectionData() {
  //   return voucherCollection.doc(uid).collection('myvouchers').snapshots();
  // }

  // // FirebaseFirestore.instance
  // //     .collection('your_collection_name')
  // //     .doc(parentDocumentId)
  // //     .collection(subCollectionName)
  // //     .get()
  // //     .then((querySnapshot) {
  // //   subcollectionData = querySnapshot.docs
  // //       .map((doc) => doc.get('field_name') as String)
  // //       .toList();
  // //   notifyListeners();
  // // })
  // //     .catchError((error) {
  // //   print('Error fetching subcollection data: $error');
  // // });
}
