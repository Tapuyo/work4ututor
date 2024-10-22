import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<bool> deleteMaterial(String classno, String path) async {
  try {
    if (path.isNotEmpty) {
      await FirebaseStorage.instance.ref().child(path).delete();
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('classMaterial')
        .where('classno', isEqualTo: classno)
        .where('reference', isEqualTo: path)
        .get();

    querySnapshot.docs.forEach((doc) async {
      await doc.reference.delete();
    });

    return true;
  } catch (e) {
    return false;
  }
}
