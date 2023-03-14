
import 'package:flutter/material.dart';

const firebaseApiKey = 'AIzaSyAn-thO0sOzHRadg_F51lMd9nOHleBmvyo';
const firebaseAppId = '1:855430775722:web:b8ef6dc3978f6e025ae1d3';
const firebaseMessagingSenderId = '855430775722';
const firebaseProjectId = 'workforyou-7c3b7';
const storageBucket = 'workforyou-7c3b7.appspot.com';

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.black87,
  backgroundColor: Colors.grey[300],
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);