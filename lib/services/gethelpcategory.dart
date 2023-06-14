import 'package:cloud_firestore/cloud_firestore.dart';

import '../data_class/helpclass.dart';

class HelpService {
//collection reference
  final CollectionReference helpcollection =
      FirebaseFirestore.instance.collection('helpcategory');

List<HelpCategory> _getHelpInformation(QuerySnapshot snapshot) {
    
    return snapshot.docs.map((helpdata) {
      return HelpCategory(
        categoryName: helpdata['categoryName'] ?? '',
        categorylist: helpdata['categoryList'] ?? '', 
      );
    }).toList();
  }

  Stream<List<HelpCategory>> get helplist {
    return helpcollection.snapshots().map(_getHelpInformation);
  }
  
}