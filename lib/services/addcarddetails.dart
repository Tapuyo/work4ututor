import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> addCardDetailsToFirestore({
  required String tutorID,
  required String bankName,
  required String cardHolderName,
  required String cardNumber,
  required String ifscCode,
  required String address,
}) async {
  CollectionReference cardDetails =
      FirebaseFirestore.instance.collection('cardDetails');

  await cardDetails.add({
    'tutorID': tutorID,
    'bankName': bankName,
    'cardHolderName': cardHolderName,
    'cardNumber': cardNumber,
    'ifscCode': ifscCode,
    'address': address,
  });
}

Future<String?> authenticateAndAddCardDetails({
  required String email,
  required String password,
  required String tutorID,
  required String bankName,
  required String cardHolderName,
  required String cardNumber,
  required String ifscCode,
  required String address,
  required BuildContext context,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null) {
      if (tutorID == userCredential.user!.uid) {
        CollectionReference cardDetails =
            FirebaseFirestore.instance.collection('tutorAccounts');

        await cardDetails.add({
          'tutorId': tutorID,
          'bankName': bankName,
          'accountHolder': cardHolderName,
          'accountNumber': cardNumber,
          'ifscCode': ifscCode,
          'address': address,
          'verifiedby': userCredential.user!.uid,
          'dateRegistered': DateTime.now(),
        });
        return 'success';
      } else {
        return 'Failed to authenticate!';
      }

      // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Bank details added successfully!')),
      // );
    }
    return 'Error saving!';
  } on FirebaseAuthException catch (e) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Failed to authenticate: ${e.message}')),
    // );
    return e.message;
  } catch (e) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('An error occurred: ${e.toString()}')),
    // );
    return e.toString();
  }
}
