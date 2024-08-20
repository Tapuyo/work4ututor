import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<LanguageData>> streamLanguageNamesFromFirestore() {
  try {
    // Get a reference to the Firestore collection
    CollectionReference languagesCollection =
        FirebaseFirestore.instance.collection('languages');

    // Listen for changes in the documents and limit the query to 1 document
    return languagesCollection.limit(1).snapshots().map(
      (querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Get the first document snapshot
          DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

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
