import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<LanguageData>> streamLanguageNamesFromFirestore() {
  try {
    // Get a reference to the Firestore collection
    CollectionReference languagesCollection =
        FirebaseFirestore.instance.collection('languages');

    // Listen for changes in the documents
    return languagesCollection.doc('YHkWYzGhH7HWgGR91WKL').snapshots().map(
      (documentSnapshot) {
        if (documentSnapshot.exists) {
          // Extract the list of country names from the document as List<String>
          List<String> namesList = List<String>.from(documentSnapshot['names']);

          // Convert the list of strings to a list of LanguageData objects
          List<LanguageData> languageNames = namesList
              .map((name) => LanguageData(languageNamesStream: name))
              .toList();
          return languageNames;
        } else {
          return [];
        }
      },
    );
  } catch (e) {
    return Stream.value([]); // Return an empty stream in case of an error
  }
}

class LanguageData {
  final String languageNamesStream;

  LanguageData({required this.languageNamesStream});
}
