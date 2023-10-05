import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<String>> streamCountryNamesFromFirestore() {
  try {
    // Get a reference to the Firestore collection
    CollectionReference countriesCollection =
        FirebaseFirestore.instance.collection('countries');

    // Listen for changes in the document
    return countriesCollection.doc('country_names').snapshots().map(
      (documentSnapshot) {
        if (documentSnapshot.exists) {
          // Extract the list of country names from the document
          List<String> countryNames =
              List<String>.from(documentSnapshot['names']);
          return countryNames;
        } else {
          return [];
        }
      },
    );
  } catch (e) {
    return Stream.value([]); // Return an empty stream in case of an error
  }
}
